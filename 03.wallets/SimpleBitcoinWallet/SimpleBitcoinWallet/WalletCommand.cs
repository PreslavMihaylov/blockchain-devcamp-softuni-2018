using HBitcoin.KeyManagement;
using NBitcoin;
using QBitNinja.Client;
using QBitNinja.Client.Models;
using System;
using System.Globalization;
using System.Text;

namespace SimpleBitcoinWallet
{
    class WalletCommand
    {
        public static void Create()
        {
            Network currentNetwork = Network.TestNet;
            string walletFilePath = @"Wallets\";
            string pw;
            string pwConfirmed;

            do
            {
                Console.Write("Enter password: ");
                pw = Console.ReadLine();
                Console.Write("Confirm password: ");
                pwConfirmed = Console.ReadLine();
                if (pw != pwConfirmed)
                {
                    Console.WriteLine("Passwords didn't match");
                    Console.WriteLine("Try again.");
                }
            } while (pw != pwConfirmed);

            try
            {
                Console.WriteLine("Enter wallet name: ");
                string walletName = Console.ReadLine();
                Mnemonic mnemonic;

                Safe safe = Safe.Create(
                    out mnemonic,
                    pw,
                    walletFilePath + walletName + ".json",
                    currentNetwork);

                Console.WriteLine("Wallet created successfully");
                Console.WriteLine("Write down the following mnemonic words.");
                Console.WriteLine("With the mnemonic AND the password, you can recover the wallet.");
                Console.WriteLine(Environment.NewLine + "------------");
                Console.Write(mnemonic);
                Console.WriteLine(Environment.NewLine + "------------");
                Console.WriteLine(
                    "Write down your private keys and keep them in a secure place. " +
                    "Only through them you can access your coins!");
                for (int i = 0; i < 10; i++)
                {
                    Console.WriteLine($"Address: {safe.GetAddress(i)} " +
                        $"-> Private key: {safe.FindPrivateKey(safe.GetAddress(i))}");
                }
            }
            catch
            {
                Console.WriteLine("Wallet already exists");
            }
        }

        public static void Recover()
        {
            Console.WriteLine(
                "Please note that the wallet cannot check if your password" +
                " is correct or not." +
                " If you provide a wrong password a wallet will be recovered " +
                "with your provided mnemonic AND password pair.");
            Console.Write("Enter password: ");
            string pw = Console.ReadLine();
            Console.Write("Enter mnemonic phrase: ");
            string mnemonic = Console.ReadLine();
            Console.Write("Enter date (yyyy-MM-dd): ");
            string date = Console.ReadLine();

            RecoverWallet(pw, mnemonic, date);
        }

        public static void Balance()
        {
            Safe safe = LoadWallet();

            Console.Write("Enter address index: ");
            int addressIndex = int.Parse(Console.ReadLine());

            QBitNinjaClient client = new QBitNinjaClient(Network.TestNet);
            BitcoinAddress address = safe.GetAddress(addressIndex);

            var balance = 
                client.GetBalance(safe.GetAddress(addressIndex), true).Result;

            decimal totalBalance = 0.0m;
            foreach (var entry in balance.Operations)
            {
                foreach (var coin in entry.ReceivedCoins)
                {
                    Money amount = (Money)coin.Amount;
                    totalBalance += amount.ToDecimal(MoneyUnit.BTC);  
                }
            }

            Console.WriteLine($"Balance for address: {address}");
            Console.WriteLine($"Balance of address: {totalBalance} BTC");
        }

        public static void History()
        {
            Safe safe = LoadWallet();

            Console.Write("Enter address index: ");
            int addressIndex = int.Parse(Console.ReadLine());

            QBitNinjaClient client = new QBitNinjaClient(Network.TestNet);
            BitcoinAddress address = safe.GetAddress(addressIndex);

            var spentBalance =
                client.GetBalance(safe.GetAddress(addressIndex), false).Result;
            var receivedBalance =
                client.GetBalance(safe.GetAddress(addressIndex), true).Result;

            Console.WriteLine("----- HISTORY -----");
            foreach (var entry in spentBalance.Operations)
            {
                foreach (var coin in entry.SpentCoins)
                {
                    decimal receivedCoins =
                        ((Money)coin.Amount).ToDecimal(MoneyUnit.BTC);

                    Console.WriteLine($"Transaction ID: {coin.Outpoint}; " +
                        $"Spent coins: {receivedCoins}");
                }
            }

            foreach (var entry in receivedBalance.Operations)
            {
                foreach (var coin in entry.ReceivedCoins)
                {
                    decimal receivedCoins =
                        ((Money)coin.Amount).ToDecimal(MoneyUnit.BTC);

                    Console.WriteLine($"Transaction ID: {coin.Outpoint}; " +
                        $"Received coins: {receivedCoins}");
                }
            }
            Console.WriteLine("-------------------");
        }

        public static void Receive()
        {
            Safe safe = LoadWallet();

            Console.WriteLine("Available addresses: ");
            Console.WriteLine(
                string.Join(Environment.NewLine, safe.GetFirstNAddresses(10)));
        }

        public static void Send()
        {
            Safe safe = LoadWallet();

            Console.Write("Enter address index: ");
            int addressIndex = int.Parse(Console.ReadLine());
            
            Console.Write("Enter Outpoint: ");
            string outpoint = Console.ReadLine();
            
            BitcoinExtKey privateKey = safe.GetBitcoinExtKey(addressIndex);

            QBitNinjaClient client = new QBitNinjaClient(Network.TestNet);
            var balance = client.GetBalance(safe.GetAddress(addressIndex), true).Result;
            OutPoint outpointToSpend = null;
            foreach (var entry in balance.Operations)
            {
                foreach (var coin in entry.ReceivedCoins)
                {
                    string currentOutpoint = coin.Outpoint.ToString();
                    if (currentOutpoint.Substring(0, currentOutpoint.Length - 2) == outpoint)
                    {
                        outpointToSpend = coin.Outpoint;
                    }
                }
            }

            Transaction transaction = new Transaction();
            transaction.Inputs.Add(new TxIn()
            {
                PrevOut = outpointToSpend,
                ScriptSig = privateKey.ScriptPubKey
            });

            Console.Write("Enter address to send to: ");
            BitcoinAddress addressToSendTo = BitcoinAddress.Create(Console.ReadLine());

            Console.Write("Enter amount to send: ");
            decimal amountToSend = decimal.Parse(Console.ReadLine());
            transaction.Outputs.Add(new TxOut()
            {
                Value = new Money(amountToSend, MoneyUnit.BTC),
                ScriptPubKey = addressToSendTo.ScriptPubKey
            });

            Console.Write("Enter amount to get back: ");
            decimal amountToGetBack = decimal.Parse(Console.ReadLine());
            transaction.Outputs.Add(new TxOut()
            {
                Value = new Money(amountToGetBack, MoneyUnit.BTC),
                ScriptPubKey = privateKey.ScriptPubKey
            });

            Console.Write("Enter message: ");
            string message = Console.ReadLine();
            var bytes = Encoding.UTF8.GetBytes(message);
            transaction.Outputs.Add(new TxOut()
            {
                Value = Money.Zero,
                ScriptPubKey = TxNullDataTemplate.Instance.GenerateScriptPubKey(bytes)
            });

            transaction.Sign(privateKey, false);
            BroadcastResponse broadcastResponse = client.Broadcast(transaction).Result;
            if (broadcastResponse.Success)
            {
                Console.WriteLine("Transaction sent");
            }
            else
            {
                Console.WriteLine("Failed to send transaction");
            }
        }

        private static void RecoverWallet(string password, string mnemonic, string date)
        {
            Network currentNetwork = Network.TestNet;
            Random rand = new Random();
            string walletName =
                "Wallets\\recovered-wallet-" + rand.Next() + ".json";

            Safe safe = Safe.Recover(
                new Mnemonic(mnemonic), password, walletName, currentNetwork,
                creationTime: DateTimeOffset.ParseExact(date,
                    "yyyy-MM-dd", CultureInfo.InvariantCulture));
            Console.WriteLine("Wallet successfully recovered");
        }

        private static Safe LoadWallet()
        {
            Console.Write("Enter password: ");
            string pw = Console.ReadLine();
            Console.Write("Enter wallet name: ");
            string walletName = Console.ReadLine();

            string walletFullPath = "Wallets\\" + walletName + ".json";

            try
            {
                return Safe.Load(pw, walletFullPath);
            }
            catch
            {
                Console.WriteLine("Failed to load wallet");
                throw;
            }
        }
    }
}
