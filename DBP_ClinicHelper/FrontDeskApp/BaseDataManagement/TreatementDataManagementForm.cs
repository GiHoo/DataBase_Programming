using System;
using System.Data;
using System.Windows.Forms;

using ClinicHelper.Utils;
using Microsoft.VisualBasic.FileIO;

namespace ClinicHelper.FrontDeskApp.BaseDataManagement
{
    public partial class TreatementDataManagementForm : Form
    {
        private DatabaseManager dbManager;
        private DataTable treatmentInfoTable;

        public TreatementDataManagementForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void SetupColumns()
        {
            dataGridView1.Columns["TREATMENT_CODE"].HeaderText = "행위 코드";
            dataGridView1.Columns["TREATMENT_CODE"].Width = 80;
            dataGridView1.Columns["TREATMENT_NAME"].HeaderText = "행위명";
            dataGridView1.Columns["TREATMENT_NAME"].MinimumWidth = 180;
            dataGridView1.Columns["UNIT_TREATMENT_COST"].HeaderText = "행위 단가";
        }

        private void RefreshTreatmentData(int? treatmentCode = null, string treatmentName = null)
        {
            dbManager.FetchTreatmentDataTable(ref treatmentInfoTable, treatmentCode, treatmentName);
            dataGridView1.DataSource = treatmentInfoTable.DefaultView;
            SetupColumns();
        }

        private void TreatementDataManagementForm_Load(object sender, EventArgs e)
        {
            RefreshTreatmentData();
        }

        private void TreatementDataManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            int? treatmentCode = null;
            if (!String.IsNullOrEmpty(textBox_FilterCode.Text))
                treatmentCode = Convert.ToInt32(textBox_FilterCode.Text);

            RefreshTreatmentData(treatmentCode, textBox_FilterName.Text);
        }

        private void button_UpdateViaCSV_Click(object sender, EventArgs e)
        {
            var result = MessageBox.Show("이 작업은 현재 저장된 의료 행위 정보를 덮어씌우니 신중하게 실행해주세요.\nCSV 데이터베이스를 적용하시겠습니까?", "경고", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
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
                    TreatmentData treatmentData = new TreatmentData
                    {
                        Code = Convert.ToInt32(fields[0]),
                        Name = fields[1],
                        UnitCost= Convert.ToInt32(fields[2]),
                    };
                    dbManager.UpdateOrInsertTreatmentData(treatmentData);
                }
            }
            openFileDialog.Dispose();

            MessageBox.Show("의료 행위 정보 업데이트를 완료했습니다", "CSV 데이터베이스 불러오기", MessageBoxButtons.OK, MessageBoxIcon.Information);
            RefreshTreatmentData();
        }
    }
}
