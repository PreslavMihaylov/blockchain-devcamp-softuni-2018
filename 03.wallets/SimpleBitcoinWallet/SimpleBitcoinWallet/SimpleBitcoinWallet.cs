using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using HBitcoin.FullBlockSpv;
using HBitcoin.KeyManagement;
using HBitcoin.Models;
using NBitcoin;
using QBitNinja.Client;
using QBitNinja.Client.Models;

namespace SimpleBitcoinWallet
{
    class SimpleBitcoinWallet
    {
        static void Main(string[] args)
        {
            List<string> viableCommands = new List<string>()
            {
                "create", "recover", "balance", "history",
                "receive", "send", "exit"
            };

            string input = String.Empty;

            while (input != "exit")
            {
                Console.Write("Enter operation " +
                        "[\"Create\", \"Recover\", " +
                        "\"Balance\", \"History\", " +
                        "\"Receive\", \"Send\", " +
                        "\"Exit\"]: ");
                input = Console.ReadLine().ToLower().Trim();

                switch (input)
                {
                    case "create":
                        WalletCommand.Create();
                        break;
                    case "recover":
                        WalletCommand.Recover();
                        break;
                    case "balance":
                        WalletCommand.Balance();
                        break;
                    case "receive":
                        WalletCommand.Receive();
                        break;
                    case "send":
                        WalletCommand.Send();
                        break;
                    case "history":
                        WalletCommand.History();
                        break;
                    case "exit":
                        break;
                    default:
                        Console.WriteLine("Unrecognized command");
                        break;
                }
            }
        }
    }
}
