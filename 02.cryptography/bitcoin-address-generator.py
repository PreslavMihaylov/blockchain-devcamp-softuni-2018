#!/usr/bin/env python

import hashlib
import sys

def sha256(text):
    return hashlib.sha256(text).digest()

def ripemd160(text):
    h = hashlib.new('ripemd160')
    h.update(text)
    return h.digest()

def ripemd160hex(text):
    h = hashlib.new('ripemd160')
    h.update(text)
    return h.hexdigest()

def append_bitcoin_network(text, byte):
    return byte + text

def concat_address(ripeHash, checksum):
    return ripeHash + checksum[0:4]

alphabet = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ'
base_count = len(alphabet)

# TODO: Fix base58 encoder
def base58_encode(text):
    """ Returns num in a base58-encoded string """
    encode = ''
    print(text)

    num = 0;
    #for byte in text:
    for i in range(len(text)):
        num = num * 256 + ord(text[i])

    while (num > 0):
        mod = num % base_count
        encode = alphabet[mod] + encode
        num = num / base_count

    if (num):
        encode = alphabet[num] + encode

    return encode

hexHash = '0450863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B23522CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6'
hashStr = hexHash.decode('hex')

pubkeySha = sha256(hashStr)
pubkeyShaRipe = ripemd160(pubkeySha)
prehashNetwork = append_bitcoin_network(pubkeyShaRipe, '\0')
publicSha = sha256(prehashNetwork)
publicShaSha = sha256(publicSha)
address = concat_address(prehashNetwork, publicShaSha);
base58addr = base58_encode(address)

print("SHA256: " + hashlib.sha256(hashStr).hexdigest())
print("RIPEMD160: " + ripemd160hex(pubkeySha))
print("PHN: " + prehashNetwork.encode('hex'))
print("Public Sha: " + publicSha.encode('hex'))
print("Public Sha Sha: " + publicShaSha.encode('hex'))
print("Address: " + address.encode('hex'))
print("Base58 Address: " + base58addr);

