using System;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.FrontDeskApp.PatientManagement
{
    public partial class PatientRegisterationForm : Form
    {

        private DatabaseManager dbManager;
        public PatientRegisterationForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void PatientRegisterationForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_SavePatient_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(textBox_PatientName.Text))
            {
                MessageBox.Show("환자명은 비어 있을 수 없습니다!");
                return;
            }
            if (string.IsNullOrEmpty(textBox_PatientJuminNo1.Text) || string.IsNullOrEmpty(textBox_PatientJuminNo2.Text))
            {
                MessageBox.Show("주민번호는 비어 있을 수 없습니다!");
                return;
            }
            if (string.IsNullOrEmpty(textBox_PatientTel.Text))
            {
                MessageBox.Show("유선전화는 비어 있을 수 없습니다!");
                return;
            }
            if (string.IsNullOrEmpty(textBox_PatientMobile.Text))
            {
                MessageBox.Show("유선전화는 비어 있을 수 없습니다!");
                return;
            }
            if (string.IsNullOrEmpty(textBox_PatientAddress.Text))
            {
                MessageBox.Show("주소는 비어 있을 수 없습니다!");
                return;
            }

            PatientData patientData = new PatientData()
            {
                Name = textBox_PatientName.Text,
                JoominNum = $"{textBox_PatientJuminNo1.Text}-{textBox_PatientJuminNo2.Text}",
                Telephone = textBox_PatientTel.Text,
                Mobile = textBox_PatientMobile.Text,
                Address = textBox_PatientAddress.Text,
                Note= textBox_PatientNote.Text
            };

            int patient_id = dbManager.CreatePatientInfo(patientData);
            MessageBox.Show($"성공적으로 환자를 등록했습니다!\n환자 ID: {patient_id}", "환자 등록", MessageBoxButtons.OK, MessageBoxIcon.Information);
            this.Close();
        }

        private void JuminNumTextChangeEvent(object sender, EventArgs e)
        {
            if (textBox_PatientJuminNo1.Text.Length == 6 && textBox_PatientJuminNo2.Text.Length > 0)
            {
                string[] juminNumTokens = new string[] { textBox_PatientJuminNo1.Text, textBox_PatientJuminNo2.Text };
                textBox_PatientBirthDate.Text = CommonUtils.CalculateBirthDateFromJuminNum(juminNumTokens);
                textBox_PatientAgeSex.Text = CommonUtils.CalculateAgeSexFromJuminNum(juminNumTokens);
            } else
            {
                textBox_PatientBirthDate.Text = "";
                textBox_PatientAgeSex.Text = "";
            }
        }
    }
}
