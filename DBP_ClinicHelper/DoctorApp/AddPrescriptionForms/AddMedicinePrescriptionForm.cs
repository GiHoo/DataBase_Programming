using ClinicHelper.DoctorApp.BaseDataSearchForms;
using ClinicHelper.Utils;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClinicHelper.DoctorApp
{
    public partial class AddMedicinePrescriptionForm : Form
    {
        private DatabaseManager dbManager;

        public MedicinePrescriptionData CreatedMedicinePrescription;

        public AddMedicinePrescriptionForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void button_SearchMedicine_Click(object sender, EventArgs e)
        {
            MedicineDataSearchForm searchForm = new MedicineDataSearchForm();
            if (searchForm.ShowDialog() == DialogResult.OK)
            {
                MessageBox.Show($"{searchForm.SelectedMedicineID}");
                MedicineData medicineData = dbManager.FetchSingleMedicineData(searchForm.SelectedMedicineID);
                textBox_Code.Text = medicineData.Code.ToString();
                textBox_Name.Text = medicineData.Name;
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(textBox_Code.Text) ||
                String.IsNullOrEmpty(textBox_Name.Text) ||
                String.IsNullOrEmpty(textBox_SingleDose.Text) ||
                String.IsNullOrEmpty(textBox_DailyDose.Text) ||
                String.IsNullOrEmpty(textBox_TotalAmount.Text))
            {
                MessageBox.Show("모든 값이 채워져있어야 합니다!", "약품 처방", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            this.CreatedMedicinePrescription = new MedicinePrescriptionData()
            {
                MedicineCode = Convert.ToInt32(textBox_Code.Text),
                MedicineName = textBox_Name.Text,
                SingleDose = Convert.ToInt32(textBox_SingleDose.Text),
                DailyDose = Convert.ToInt32(textBox_DailyDose.Text),
                TotalAmount = Convert.ToInt32(textBox_TotalAmount.Text)
            };
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void AddMedicinePrescriptionForm_Load(object sender, EventArgs e)
        {

        }

        private void AddMedicinePrescriptionForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
