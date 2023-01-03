using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;
using Microsoft.VisualBasic.FileIO;

namespace ClinicHelper.FrontDeskApp.BaseDataManagement
{
    public partial class MedicineDataManagementForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable medicineInfoTable;

        public MedicineDataManagementForm()
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

        private void button_UpdateViaCSV_Click(object sender, EventArgs e)
        {
            var result = MessageBox.Show("이 작업은 현재 저장된 의약품 정보를 덮어씌우니 신중하게 실행해주세요.\nCSV 데이터베이스를 적용하시겠습니까?", "경고", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result != DialogResult.Yes) return;

            OpenFileDialog openFileDialog = new OpenFileDialog
            {
                Filter = "csv 파일 (*.csv)|*.csv",
                RestoreDirectory = true
            };

            if (openFileDialog.ShowDialog() != DialogResult.OK) return;

            using (TextFieldParser parser = new TextFieldParser(openFileDialog.FileName, System.Text.Encoding.UTF8))
            {
                parser.CommentTokens = new string[] { "#" };
                parser.SetDelimiters(new string[] { "," });
                parser.ReadLine();

                while (!parser.EndOfData)
                {
                    string[] fields = parser.ReadFields();
                    MedicineData medicineData = new MedicineData
                    {
                        Code = Convert.ToInt32(fields[0]),
                        Name = fields[1]
                    };
                    dbManager.UpdateOrInsertMedicineData(medicineData);
                }
            }
            openFileDialog.Dispose();

            MessageBox.Show("질병 정보 업데이트를 완료했습니다", "CSV 데이터베이스 불러오기", MessageBoxButtons.OK, MessageBoxIcon.Information);
            RefreshMedicineList();
        }
    }
}
