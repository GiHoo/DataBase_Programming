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
    public partial class AddTreatmentPrescriptionForm : Form
    {
        private DatabaseManager dbManager;
        public TreatmentPrescriptionData CreatedTreatmentData;

        public AddTreatmentPrescriptionForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void button_SearchTreatment_Click(object sender, EventArgs e)
        {
            TreatmentDataSearchForm searchForm = new TreatmentDataSearchForm();
            if (searchForm.ShowDialog() == DialogResult.OK)
            {
                TreatmentData treatmentData = dbManager.FetchSingleTreatmentData(searchForm.SelectedTreatementID);
                textBox_Code.Text = treatmentData.Code.ToString();
                textBox_Name.Text = treatmentData.Name;
            }
        }

        private void button_SaveTreatment_Click(object sender, EventArgs e)
        {
            this.CreatedTreatmentData = new TreatmentPrescriptionData()
            {
                TreatmentCode = Convert.ToInt32(textBox_Code.Text),
                TreatmentName = textBox_Name.Text,
                TotalCount = Convert.ToInt32(textBox_TotalCount.Text)
            };
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void AddTreatmentPrescriptionForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }
    }
}
