using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;

using ClinicHelper.Utils;
using Microsoft.VisualBasic.FileIO;

namespace ClinicHelper.FrontDeskApp.BaseDataManagement
{
    public partial class DiseaseDataManagementForm : Form
    {

        private DatabaseManager dbManager;
        private DataTable diseaseInfoTable;
        public DiseaseDataManagementForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void TranslateColumnHeader()
        {
            dataGridView1.Columns[0].HeaderText = "질병 코드";
            dataGridView1.Columns[1].HeaderText = "질병명";
            dataGridView1.Columns[2].HeaderText = "진찰 단가";
        }

        private void RefreshDiseaseList(string KCDCode = null, string diseaseName = null)
        {
            dbManager.FetchDiseaseDataTable(ref diseaseInfoTable, KCDCode, diseaseName);
            dataGridView1.DataSource = diseaseInfoTable.DefaultView;
            TranslateColumnHeader();
        }


        private void DiseaseDataManagementForm_Load(object sender, EventArgs e)
        {
            RefreshDiseaseList();
        }

        private void DiseaseDataManagementForm_KeyUp(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Escape)
            {
                this.Close();
            }
        }

        private void button_UpdateViaCSV_Click(object sender, EventArgs e)
        {
            var result = MessageBox.Show("이 작업은 현재 저장된 질병 코드 정보를 덮어씌우니 신중하게 실행해주세요.\nCSV 데이터베이스를 적용하시겠습니까?", "경고", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
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
                    DiseaseData diseaseData = new DiseaseData
                    {
                        KCDCode = fields[0],
                        Name = fields[1],
                        DiagnosisCost = Convert.ToInt32(fields[2])
                    };
                    dbManager.UpdateOrInsertDiseaseData(diseaseData);
                }
            }
            openFileDialog.Dispose();

            MessageBox.Show("질병 정보 업데이트를 완료했습니다", "CSV 데이터베이스 불러오기", MessageBoxButtons.OK, MessageBoxIcon.Information);
            RefreshDiseaseList();
        }

        private void button_ApplyFilter_Click(object sender, EventArgs e)
        {
            RefreshDiseaseList(textBox_FilterKCDCode.Text, textBox_FilterDiseaseName.Text);
        }
    }
}
