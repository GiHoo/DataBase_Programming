using ClinicHelper.DoctorApp.BaseDataSearchForms;
using ClinicHelper.DoctorApp.ViewRecordForms;
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
    public partial class MainForm : Form
    {
        private DatabaseManager dbManager;

        private PatientData patientData;
        private DiagnosisRegistrationData diagnosisRegistrationData;

        private List<MedicinePrescriptionData> medicinePrescriptions;
        private List<TreatmentPrescriptionData> treatmentPrescriptions;

        private bool ready = false;

        public MainForm()
        {
            InitializeComponent();
            dbManager = DatabaseManager.Instance;
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            medicinePrescriptions = new List<MedicinePrescriptionData>();
            treatmentPrescriptions = new List<TreatmentPrescriptionData>();
            EnableEditor(false);
        }

        private void EnableEditor(bool enable)
        {
            button_ViewPreviousDiagnosisRecords.Enabled = enable;
            textBox_KCDCode.Enabled = enable;
            button_SearchKCDCode.Enabled = enable;
            textBox_DoctorComment.Enabled = enable;
            button_AddMedicinePrescription.Enabled = enable;
            listView1.Enabled = enable;
            button_AddTreatmentPrescription.Enabled = enable;
            listView2.Enabled = enable;
            button_ResetUserInput.Enabled = enable;
            button_SaveDiagnosisRecord.Enabled = enable;

            if (!enable)
                ClearEditor(false);
        }

        private void ClearEditor(bool userInputOnly)
        {
            textBox_DoctorComment.Clear();
            textBox_KCDCode.Clear();
            listView1.Items.Clear();
            listView2.Items.Clear();
            medicinePrescriptions.Clear();
            treatmentPrescriptions.Clear();
            if (userInputOnly)
                return;

            ready = false;
            textBox_PatientID.Clear();
            textBox_PatientName.Clear();
            textBox_PatientJuminNo1.Clear();
            textBox_PatientJuminNo2.Clear();
            textBox_PatientAddress.Clear();
            textBox_PatientMobile.Clear();
            textBox_PatientTel.Clear();
            textBox_PatientAgeSex.Clear();
            textBox_PatientBirthDate.Clear();
            textBox_PatientNote.Clear();
            textBox_RegisterDateTime.Clear();
            textBox_PatientStatus.Clear();
        }

        private void ToolStripMenu_환자조회_Click(object sender, EventArgs e)
        {
            new PatientSearchForm().ShowDialog();
        }

        private void HandleRegistrationLoad()
        {
            ViewDiagnosisRegistrations viewDiagnosisRegistrations = new ViewDiagnosisRegistrations();
            if (viewDiagnosisRegistrations.ShowDialog() == DialogResult.OK)
            {
                int diagnosisRegistrationID = viewDiagnosisRegistrations.SelectedRegistrationID;
                diagnosisRegistrationData = dbManager.FetchSingleDiagnosisRegistrationData(diagnosisRegistrationID);

                textBox_RegisterDateTime.Text = diagnosisRegistrationData.RegisterDateTime.ToString();
                textBox_PatientStatus.Text = diagnosisRegistrationData.PatientStatus;

                patientData = dbManager.FetchSinglePatientData(diagnosisRegistrationData.PatientID);

                textBox_PatientID.Text = patientData.PatientID.ToString();
                textBox_PatientName.Text = patientData.Name.ToString();
                string[] juminNoTokens = patientData.JoominNum.ToString().Split('-');
                textBox_PatientJuminNo1.Text = juminNoTokens[0];
                textBox_PatientJuminNo2.Text = juminNoTokens[1];
                textBox_PatientBirthDate.Text = CommonUtils.CalculateBirthDateFromJuminNum(juminNoTokens);
                textBox_PatientAgeSex.Text = CommonUtils.CalculateAgeSexFromJuminNum(juminNoTokens);
                textBox_PatientTel.Text = patientData.Telephone.ToString();
                textBox_PatientMobile.Text = patientData.Mobile.ToString();
                textBox_PatientAddress.Text = patientData.Address.ToString();
                textBox_PatientNote.Text = patientData.Note.ToString();

                EnableEditor(true);
            }
        }

        private void ToolStripMenu_진료대기조회_Click(object sender, EventArgs e)
        {
            HandleRegistrationLoad();
        }

        private void ToolStripMenuItem_질병검색_Click(object sender, EventArgs e)
        {
            new DiseaseDataSearchForm().ShowDialog();
        }

        private void ToolStripMenuItem_약품검색_Click(object sender, EventArgs e)
        {
            new MedicineDataSearchForm().ShowDialog();
        }

        private void ToolStripMenuItem_의료행위검색_Click(object sender, EventArgs e)
        {
            new TreatmentDataSearchForm().ShowDialog();
        }

        private void button_SearchKCDCode_Click(object sender, EventArgs e)
        {
            DiseaseDataSearchForm searchForm = new DiseaseDataSearchForm();
            if (searchForm.ShowDialog() == DialogResult.OK)
                textBox_KCDCode.Text = searchForm.SelectedKCDCode;
        }

        private void button_SearchPatient_Click(object sender, EventArgs e)
        {
            new PatientSearchForm().ShowDialog();
        }

        private void button_RegisterPatient_Click(object sender, EventArgs e)
        {
            HandleRegistrationLoad();
        }

        private void button_NaviSearchKCDCode_Click(object sender, EventArgs e)
        {
            new DiseaseDataSearchForm().ShowDialog();
        }

        private void button_NaviSearchMedicine_Click(object sender, EventArgs e)
        {
            new MedicineDataSearchForm().ShowDialog();
        }

        private void button_NaviSearchTreatment_Click(object sender, EventArgs e)
        {
            new TreatmentDataSearchForm().ShowDialog();
        }

        private void RefreshMedicineListView()
        {
            listView1.Items.Clear();
            foreach (MedicinePrescriptionData data in medicinePrescriptions)
            {
                ListViewItem item = new ListViewItem(data.MedicineCode.ToString());
                item.SubItems.Add(data.MedicineName);
                item.SubItems.Add(data.SingleDose.ToString());
                item.SubItems.Add(data.DailyDose.ToString());
                item.SubItems.Add(data.TotalAmount.ToString());
                listView1.Items.Add(item);
            }
        }

        private void RefreshTreatmentListView()
        {
            listView2.Items.Clear();
            foreach (TreatmentPrescriptionData data in treatmentPrescriptions)
            {
                ListViewItem item = new ListViewItem(data.TreatmentCode.ToString());
                item.SubItems.Add(data.TreatmentName);
                item.SubItems.Add(data.TotalCount.ToString());
                listView2.Items.Add(item);
            }
        }

        private void button_AddMedicinePrescription_Click(object sender, EventArgs e)
        {
            AddMedicinePrescriptionForm addForm = new AddMedicinePrescriptionForm();
            if (addForm.ShowDialog() == DialogResult.OK)
            {
                medicinePrescriptions.Add(addForm.CreatedMedicinePrescription);
                RefreshMedicineListView();
            }
        }
        private void button_AddTreatmentPrescription_Click(object sender, EventArgs e)
        {
            AddTreatmentPrescriptionForm addForm = new AddTreatmentPrescriptionForm();
            if (addForm.ShowDialog() == DialogResult.OK)
            {
                treatmentPrescriptions.Add(addForm.CreatedTreatmentData);
                RefreshTreatmentListView();
            }
        }

        private void button_ResetUserInput_Click(object sender, EventArgs e)
        {
            var result = MessageBox.Show("정말로 입력 내용을 초기화 하시겠습니까?", "경고", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);
            if (result == DialogResult.Yes)
                ClearEditor(true);
        }

        private void button_SaveDiagnosisRecord_Click(object sender, EventArgs e)
        {
            var transaction = dbManager.GetTransaction();
            try
            {
                DiagnosisRecordData recordData = new DiagnosisRecordData()
                {
                    RegistrationID = diagnosisRegistrationData.RegistrationID,
                    DiagnosisDateTime = DateTime.Now,
                    KCDCode = textBox_KCDCode.Text,
                    DoctorComment = textBox_DoctorComment.Text,
                    DoctorName = textBox_DoctorName.Text,
                    ClinicName = textBox_ClinicName.Text
                };
                dbManager.CreateDiagnosisRecord(recordData, transaction);
                dbManager.CreateMedicinePrescription(recordData.RegistrationID, medicinePrescriptions, transaction);
                dbManager.CreateTreatementPrescription(recordData.RegistrationID, treatmentPrescriptions, transaction);
                dbManager.UpdateDiagnosisRegistrationStatus(recordData.RegistrationID, 1, transaction);

                DiseaseData diseaseData = dbManager.FetchSingleDiseaseData(textBox_KCDCode.Text);

                int treatmentCostSum = 0;
                foreach (TreatmentPrescriptionData prescriptionData in treatmentPrescriptions)
                {
                    TreatmentData treatamentData = dbManager.FetchSingleTreatmentData(prescriptionData.TreatmentCode);
                    treatmentCostSum += treatamentData.UnitCost * prescriptionData.TotalCount;
                }

                PaymentData paymentData = new PaymentData()
                {
                    RegistrationID = recordData.RegistrationID,
                    TotalDiagnosisCost = diseaseData.DiagnosisCost,
                    TotalTreatmentCost = treatmentCostSum,
                    PaymentDone = false
                };
                dbManager.CreatePaymentInfo(paymentData, transaction);
                transaction.Commit();
                MessageBox.Show("성공적으로 진료 기록을 저장했습니다!", "진료 기록 저장", MessageBoxButtons.OK, MessageBoxIcon.Information);
                EnableEditor(false);
            } catch (Exception ex)
            {
                transaction.Rollback();
                MessageBox.Show("진료 기록을 저장하지 못했습니다!\n" + ex.ToString(), "진료 기록 저장", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            transaction.Dispose();
        }

        private void button_ViewPreviousDiagnosisRecords_Click(object sender, EventArgs e)
        {
            new ViewPreviousRegistrationsForm(patientData).ShowDialog();
        }
    }
}
