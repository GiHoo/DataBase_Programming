using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClinicHelper.Utils
{
    public static class CommonUtils
    {
        private static int CalculateBornYearFromJuminNum(string[] juminNumToknes)
        {
            int baseYear;
            int sexCategory = juminNumToknes[1][0] - '0';
            switch (sexCategory)
            {
                case 0:
                case 9:
                    baseYear = 1800;
                    break;

                case 1:
                case 2:
                case 5:
                case 6:
                    baseYear = 1900;
                    break;

                case 3:
                case 4:
                case 7:
                case 8:
                default:
                    baseYear = 2000;
                    break;
            }
            return baseYear + int.Parse(juminNumToknes[0].Substring(0, 2));
        }

        public static string CalculateBirthDateFromJuminNum(string[] juminNumToknes)
        {
            int bornYear = CalculateBornYearFromJuminNum(juminNumToknes);
            return $"{bornYear}-{juminNumToknes[0].Substring(2, 2)}-{juminNumToknes[0].Substring(4,2)}";
        }


        public static string CalculateAgeSexFromJuminNum(string[] juminNumToknes)
        {
            int bornYear = CalculateBornYearFromJuminNum(juminNumToknes);
            int sexCategory = juminNumToknes[1][0] - '0';

            char gender = sexCategory % 2 == 0 ? 'F' : 'M';
            int age = DateTime.Now.Year - bornYear;

            return $"{age}({gender})";
        }
    }
}
