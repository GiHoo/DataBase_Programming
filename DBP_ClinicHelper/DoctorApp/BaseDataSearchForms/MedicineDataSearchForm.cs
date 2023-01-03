using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;

namespace ClinicHelper.DoctorApp.BaseDataSearchForms
{
    public partial class MedicineDataSearchForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable medicineInfoTable;

        public int SelectedMedicineID;

        public MedicineDataSearchForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView1.Columns[0].HeaderText = "약품 코드";
            dataGridView1.Columns[1].HeaderText = "약품명";
        }

        public void RefreshMedicineList(int? medicineID = null, string medicineName = null)
        {
            dbManager.FetchMedicineDataTable(ref medicineInfoTable, medicineID, medicineName);
            dataGridView1.DataSource = medicineInfoTable;
            TranslateColumnHeader();
        }

        private void MedicineDataManagementForm_Load(object sender, EventArgs e)
        {
            RefreshMedicineList();
        }

        private void MedicineDataManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            int? medicineID = null;
            if (!String.IsNullOrEmpty(textBox_FilterCode.Text))
                medicineID = Convert.ToInt32(textBox_FilterCode.Text);

            RefreshMedicineList(medicineID, textBox_FilterName.Text);
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            this.SelectedMedicineID = Convert.ToInt32(medicineInfoTable.Rows[e.RowIndex]["medicine_code"]);
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        private void EditorCommonKeyUpHandler(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                button_ApplyFilter.PerformClick();
            }
        }
    }
}
