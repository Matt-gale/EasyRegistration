using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using System.Linq;

namespace EasyRegistration.Library
{
    public class RSAEncryption
    {

        public class RSAEncryptionDTO
        {
            public RSAParameters Key { get; set; }
            public byte[] Data { get; set; }
        }

        public static class RSAEncryptionHelper
        {
            //https://msdn.microsoft.com/en-us/library/system.security.cryptography.rsacryptoserviceprovider(v=vs.110).aspx

            public static RSAParameters GeneratePrivateKey()
            {
                using (var provider = RSA.Create())
                {
                    return provider.ExportParameters(true);
                }
            }

            public static RSAParameters GetPublicKeyFromPrivateKey(RSAParameters privateKey)
            {
                using (var rsa = RSA.Create())
                {
                    rsa.ImportParameters(privateKey);
                    return rsa.ExportParameters(false);
                }
            }

            public static string EncryptUTF32RSA(string input)
            {
                byte[] inputBytes = Encoding.UTF32.GetBytes(input);

                using (var rsa = RSA.Create())
                {
                    rsa.ImportParameters(GetEncryptionKey());
                    var outputBytes = rsa.Encrypt(inputBytes, RSAEncryptionPadding.Pkcs1);

                    string output = Convert.ToBase64String(outputBytes);

                    return output;
                }
            }

            public static byte[] EncryptRSA(byte[] input)
            {
                using (var rsa = RSA.Create())
                {
                    rsa.ImportParameters(GetEncryptionKey());
                    var output = rsa.Encrypt(input, RSAEncryptionPadding.Pkcs1);
                    return output;
                }
            }

            public static string DecryptUTF32RSA(string input)
            {
                byte[] inputBytes = Convert.FromBase64String(input);

                using (var rsa = RSA.Create())
                {
                    rsa.ImportParameters(GetEncryptionKey());
                    var outputBytes = rsa.Decrypt(inputBytes, RSAEncryptionPadding.Pkcs1);

                    string output = Encoding.UTF32.GetString(outputBytes);

                    return output;
                }
            }

            public static byte[] DecryptRSA(byte[] input)
            {
                using (var rsa = RSA.Create())
                {
                    rsa.ImportParameters(GetEncryptionKey());
                    var output = rsa.Decrypt(input, RSAEncryptionPadding.Pkcs1);
                    return output;
                }
            }

            public static RSAParameters? ImportKey(string privateKeyString, char delimiter = ';', string nullValue = "-")
            {
                if (string.IsNullOrWhiteSpace(privateKeyString)) return null;

                if (!privateKeyString.Contains(delimiter)) return null;

                var stringFields = privateKeyString.Split(delimiter);
                if (stringFields.Length != 8) return null;

                var byteFields = stringFields.Select(f =>
                {
                    if (f == nullValue) return null;
                    return f.FromBase64String();
                }).ToArray();

                var parameters = new RSAParameters
                {
                    D = byteFields[0],
                    DP = byteFields[1],
                    DQ = byteFields[2],
                    Exponent = byteFields[3],
                    InverseQ = byteFields[4],
                    Modulus = byteFields[5],
                    P = byteFields[6],
                    Q = byteFields[7],
                };

                return parameters;
            }


            public static string ExportKey(RSAParameters parameters, char delimiter = ';', string nullValue = "-")
            {
                var output = new List<string>();

                if (parameters.D == null) output.Add(nullValue);
                else output.Add(parameters.D.ToBase64String());

                if (parameters.DP == null) output.Add(nullValue);
                else output.Add(parameters.DP.ToBase64String());

                if (parameters.DQ == null) output.Add(nullValue);
                else output.Add(parameters.DQ.ToBase64String());

                if (parameters.Exponent == null) output.Add(nullValue);
                else output.Add(parameters.Exponent.ToBase64String());

                if (parameters.InverseQ == null) output.Add(nullValue);
                else output.Add(parameters.InverseQ.ToBase64String());

                if (parameters.Modulus == null) output.Add(nullValue);
                else output.Add(parameters.Modulus.ToBase64String());

                if (parameters.P == null) output.Add(nullValue);
                else output.Add(parameters.P.ToBase64String());

                if (parameters.Q == null) output.Add(nullValue);
                else output.Add(parameters.Q.ToBase64String());

                return output.Aggregate((f, s) => f + delimiter + s);
            }

            private static RSAParameters GetEncryptionKey()
            {
                var key = Environment.GetEnvironmentVariable("ENCRYPTION_KEY");
                var rsaparameters = ImportKey(key);
                if (!rsaparameters.HasValue) throw new ArgumentException("No Encryption key set up for environment");

                return rsaparameters.Value;
            }

        }
    }
}
