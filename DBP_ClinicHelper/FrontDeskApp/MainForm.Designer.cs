namespace ClinicHelper.FrontDeskApp
{
    partial class MainForm
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다. 
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마세요.
        /// </summary>
        private void InitializeComponent()
        {
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.환자관리ToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_RegisterPatient = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_SearchPatient = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_PaymentManagement = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_BaseDataManagement = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_ManageDiseaseData = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_ManageMedicineData = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_ManageTreatmentData = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_StatisticData = new System.Windows.Forms.ToolStripMenuItem();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.textBox_PatientJuminNo1 = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.textBox_PatientID = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.textBox_PatientName = new System.Windows.Forms.TextBox();
            this.textBox_PatientJuminNo2 = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.textBox_PatientBirthDate = new System.Windows.Forms.TextBox();
            this.textBox_PatientAgeSex = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.textBox_PatientMobile = new System.Windows.Forms.TextBox();
            this.textBox_PatientTel = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.textBox_PatientNote = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.textBox_PatientAddress = new System.Windows.Forms.TextBox();
            this.button_RegisterPatient = new System.Windows.Forms.Button();
            this.button_SearchPatient = new System.Windows.Forms.Button();
            this.button_ManagePayment = new System.Windows.Forms.Button();
            this.labelDivider1 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.button_SavePatient = new System.Windows.Forms.Button();
            this.label11 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.textBox_PatientStatus = new System.Windows.Forms.TextBox();
            this.button_RegisterDiagnosis = new System.Windows.Forms.Button();
            this.label13 = new System.Windows.Forms.Label();
            this.label14 = new System.Windows.Forms.Label();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.button_ViewDiagnosisRecords = new System.Windows.Forms.Button();
            this.menuStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.BackColor = System.Drawing.SystemColors.ControlLight;
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.환자관리ToolStripMenuItem,
            this.ToolStripMenuItem_PaymentManagement,
            this.ToolStripMenuItem_BaseDataManagement,
            this.ToolStripMenuItem_StatisticData});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1199, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // 환자관리ToolStripMenuItem
            // 
            this.환자관리ToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ToolStripMenuItem_RegisterPatient,
            this.ToolStripMenuItem_SearchPatient});
            this.환자관리ToolStripMenuItem.Name = "환자관리ToolStripMenuItem";
            this.환자관리ToolStripMenuItem.Size = new System.Drawing.Size(71, 20);
            this.환자관리ToolStripMenuItem.Text = "환자 관리";
            // 
            // ToolStripMenuItem_RegisterPatient
            // 
            this.ToolStripMenuItem_RegisterPatient.Name = "ToolStripMenuItem_RegisterPatient";
            this.ToolStripMenuItem_RegisterPatient.Size = new System.Drawing.Size(126, 22);
            this.ToolStripMenuItem_RegisterPatient.Text = "환자 등록";
            this.ToolStripMenuItem_RegisterPatient.Click += new System.EventHandler(this.OpenRegisterPatientEvent);
            // 
            // ToolStripMenuItem_SearchPatient
            // 
            this.ToolStripMenuItem_SearchPatient.Name = "ToolStripMenuItem_SearchPatient";
            this.ToolStripMenuItem_SearchPatient.Size = new System.Drawing.Size(126, 22);
            this.ToolStripMenuItem_SearchPatient.Text = "환자 검색";
            this.ToolStripMenuItem_SearchPatient.Click += new System.EventHandler(this.OpenSearchPatientEvent);
            // 
            // ToolStripMenuItem_PaymentManagement
            // 
            this.ToolStripMenuItem_PaymentManagement.Name = "ToolStripMenuItem_PaymentManagement";
            this.ToolStripMenuItem_PaymentManagement.Size = new System.Drawing.Size(71, 20);
            this.ToolStripMenuItem_PaymentManagement.Text = "수납 관리";
            this.ToolStripMenuItem_PaymentManagement.Click += new System.EventHandler(this.OpenPaymentManagementEvent);
            // 
            // ToolStripMenuItem_BaseDataManagement
            // 
            this.ToolStripMenuItem_BaseDataManagement.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ToolStripMenuItem_ManageDiseaseData,
            this.ToolStripMenuItem_ManageMedicineData,
            this.ToolStripMenuItem_ManageTreatmentData});
            this.ToolStripMenuItem_BaseDataManagement.Name = "ToolStripMenuItem_BaseDataManagement";
            this.ToolStripMenuItem_BaseDataManagement.Size = new System.Drawing.Size(99, 20);
            this.ToolStripMenuItem_BaseDataManagement.Text = "기초 정보 관리";
            // 
            // ToolStripMenuItem_ManageDiseaseData
            // 
            this.ToolStripMenuItem_ManageDiseaseData.Name = "ToolStripMenuItem_ManageDiseaseData";
            this.ToolStripMenuItem_ManageDiseaseData.Size = new System.Drawing.Size(182, 22);
            this.ToolStripMenuItem_ManageDiseaseData.Text = "질병 코드 관리";
            this.ToolStripMenuItem_ManageDiseaseData.Click += new System.EventHandler(this.ToolStripMenuItem_ManageDiseaseData_Click);
            // 
            // ToolStripMenuItem_ManageMedicineData
            // 
            this.ToolStripMenuItem_ManageMedicineData.Name = "ToolStripMenuItem_ManageMedicineData";
            this.ToolStripMenuItem_ManageMedicineData.Size = new System.Drawing.Size(182, 22);
            this.ToolStripMenuItem_ManageMedicineData.Text = "의약품 목록 관리";
            this.ToolStripMenuItem_ManageMedicineData.Click += new System.EventHandler(this.ToolStripMenuItem_ManageMedicineData_Click);
            // 
            // ToolStripMenuItem_ManageTreatmentData
            // 
            this.ToolStripMenuItem_ManageTreatmentData.Name = "ToolStripMenuItem_ManageTreatmentData";
            this.ToolStripMenuItem_ManageTreatmentData.Size = new System.Drawing.Size(182, 22);
            this.ToolStripMenuItem_ManageTreatmentData.Text = "의료 행위 목록 관리";
            this.ToolStripMenuItem_ManageTreatmentData.Click += new System.EventHandler(this.ToolStripMenuItem_ManageTreatmentData_Click);
            // 
            // ToolStripMenuItem_StatisticData
            // 
            this.ToolStripMenuItem_StatisticData.Name = "ToolStripMenuItem_StatisticData";
            this.ToolStripMenuItem_StatisticData.Size = new System.Drawing.Size(71, 20);
            this.ToolStripMenuItem_StatisticData.Text = "통계 정보";
            this.ToolStripMenuItem_StatisticData.Click += new System.EventHandler(this.ToolStripMenuItem_StatisticData_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14F);
            this.label1.Location = new System.Drawing.Point(17, 94);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(91, 19);
            this.label1.TabIndex = 2;
            this.label1.Text = "환자 정보";
            // 
            // label2
            // 
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Font = new System.Drawing.Font("굴림", 12F);
            this.label2.Location = new System.Drawing.Point(21, 129);
            this.label2.Name = "label2";
            this.label2.Padding = new System.Windows.Forms.Padding(3);
            this.label2.Size = new System.Drawing.Size(80, 26);
            this.label2.TabIndex = 3;
            this.label2.Text = "환자 ID";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientJuminNo1
            // 
            this.textBox_PatientJuminNo1.Enabled = false;
            this.textBox_PatientJuminNo1.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo1.Location = new System.Drawing.Point(107, 195);
            this.textBox_PatientJuminNo1.Name = "textBox_PatientJuminNo1";
            this.textBox_PatientJuminNo1.Size = new System.Drawing.Size(66, 26);
            this.textBox_PatientJuminNo1.TabIndex = 6;
            this.textBox_PatientJuminNo1.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // label3
            // 
            this.label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label3.Font = new System.Drawing.Font("굴림", 12F);
            this.label3.Location = new System.Drawing.Point(21, 195);
            this.label3.Name = "label3";
            this.label3.Padding = new System.Windows.Forms.Padding(3);
            this.label3.Size = new System.Drawing.Size(80, 26);
            this.label3.TabIndex = 3;
            this.label3.Text = "주민번호";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientID
            // 
            this.textBox_PatientID.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientID.Location = new System.Drawing.Point(107, 129);
            this.textBox_PatientID.Name = "textBox_PatientID";
            this.textBox_PatientID.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientID.TabIndex = 4;
            this.textBox_PatientID.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textBox_PatientID_KeyUp);
            // 
            // label4
            // 
            this.label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label4.Font = new System.Drawing.Font("굴림", 12F);
            this.label4.Location = new System.Drawing.Point(21, 162);
            this.label4.Name = "label4";
            this.label4.Padding = new System.Windows.Forms.Padding(3);
            this.label4.Size = new System.Drawing.Size(80, 26);
            this.label4.TabIndex = 3;
            this.label4.Text = "환자명";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientName
            // 
            this.textBox_PatientName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientName.Location = new System.Drawing.Point(107, 162);
            this.textBox_PatientName.Name = "textBox_PatientName";
            this.textBox_PatientName.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientName.TabIndex = 5;
            this.textBox_PatientName.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            this.textBox_PatientName.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textBox_PatientName_KeyUp);
            // 
            // textBox_PatientJuminNo2
            // 
            this.textBox_PatientJuminNo2.Enabled = false;
            this.textBox_PatientJuminNo2.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo2.Location = new System.Drawing.Point(179, 195);
            this.textBox_PatientJuminNo2.Name = "textBox_PatientJuminNo2";
            this.textBox_PatientJuminNo2.Size = new System.Drawing.Size(73, 26);
            this.textBox_PatientJuminNo2.TabIndex = 7;
            this.textBox_PatientJuminNo2.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // label5
            // 
            this.label5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label5.Font = new System.Drawing.Font("굴림", 12F);
            this.label5.Location = new System.Drawing.Point(267, 195);
            this.label5.Name = "label5";
            this.label5.Padding = new System.Windows.Forms.Padding(3);
            this.label5.Size = new System.Drawing.Size(80, 26);
            this.label5.TabIndex = 3;
            this.label5.Text = "생년월일";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientBirthDate
            // 
            this.textBox_PatientBirthDate.Enabled = false;
            this.textBox_PatientBirthDate.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientBirthDate.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientBirthDate.Location = new System.Drawing.Point(353, 195);
            this.textBox_PatientBirthDate.Name = "textBox_PatientBirthDate";
            this.textBox_PatientBirthDate.ReadOnly = true;
            this.textBox_PatientBirthDate.Size = new System.Drawing.Size(92, 26);
            this.textBox_PatientBirthDate.TabIndex = 10;
            // 
            // textBox_PatientAgeSex
            // 
            this.textBox_PatientAgeSex.Enabled = false;
            this.textBox_PatientAgeSex.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAgeSex.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientAgeSex.Location = new System.Drawing.Point(451, 195);
            this.textBox_PatientAgeSex.Name = "textBox_PatientAgeSex";
            this.textBox_PatientAgeSex.ReadOnly = true;
            this.textBox_PatientAgeSex.Size = new System.Drawing.Size(47, 26);
            this.textBox_PatientAgeSex.TabIndex = 11;
            // 
            // label6
            // 
            this.label6.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label6.Font = new System.Drawing.Font("굴림", 12F);
            this.label6.Location = new System.Drawing.Point(267, 129);
            this.label6.Name = "label6";
            this.label6.Padding = new System.Windows.Forms.Padding(3);
            this.label6.Size = new System.Drawing.Size(80, 26);
            this.label6.TabIndex = 3;
            this.label6.Text = "유선전화";
            this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label9
            // 
            this.label9.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label9.Font = new System.Drawing.Font("굴림", 12F);
            this.label9.Location = new System.Drawing.Point(267, 162);
            this.label9.Name = "label9";
            this.label9.Padding = new System.Windows.Forms.Padding(3);
            this.label9.Size = new System.Drawing.Size(80, 26);
            this.label9.TabIndex = 3;
            this.label9.Text = "이동전화";
            this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientMobile
            // 
            this.textBox_PatientMobile.Enabled = false;
            this.textBox_PatientMobile.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientMobile.Location = new System.Drawing.Point(353, 162);
            this.textBox_PatientMobile.Name = "textBox_PatientMobile";
            this.textBox_PatientMobile.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientMobile.TabIndex = 9;
            this.textBox_PatientMobile.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // textBox_PatientTel
            // 
            this.textBox_PatientTel.Enabled = false;
            this.textBox_PatientTel.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientTel.Location = new System.Drawing.Point(353, 129);
            this.textBox_PatientTel.Name = "textBox_PatientTel";
            this.textBox_PatientTel.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientTel.TabIndex = 8;
            this.textBox_PatientTel.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // label7
            // 
            this.label7.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label7.Font = new System.Drawing.Font("굴림", 12F);
            this.label7.Location = new System.Drawing.Point(21, 261);
            this.label7.Name = "label7";
            this.label7.Padding = new System.Windows.Forms.Padding(3);
            this.label7.Size = new System.Drawing.Size(80, 26);
            this.label7.TabIndex = 3;
            this.label7.Text = "비고";
            this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientNote
            // 
            this.textBox_PatientNote.Enabled = false;
            this.textBox_PatientNote.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientNote.Location = new System.Drawing.Point(107, 261);
            this.textBox_PatientNote.Multiline = true;
            this.textBox_PatientNote.Name = "textBox_PatientNote";
            this.textBox_PatientNote.Size = new System.Drawing.Size(391, 73);
            this.textBox_PatientNote.TabIndex = 13;
            this.textBox_PatientNote.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // label8
            // 
            this.label8.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label8.Font = new System.Drawing.Font("굴림", 12F);
            this.label8.Location = new System.Drawing.Point(21, 228);
            this.label8.Name = "label8";
            this.label8.Padding = new System.Windows.Forms.Padding(3);
            this.label8.Size = new System.Drawing.Size(80, 26);
            this.label8.TabIndex = 3;
            this.label8.Text = "주소지";
            this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientAddress
            // 
            this.textBox_PatientAddress.Enabled = false;
            this.textBox_PatientAddress.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAddress.Location = new System.Drawing.Point(107, 228);
            this.textBox_PatientAddress.Name = "textBox_PatientAddress";
            this.textBox_PatientAddress.Size = new System.Drawing.Size(391, 26);
            this.textBox_PatientAddress.TabIndex = 12;
            this.textBox_PatientAddress.TextChanged += new System.EventHandler(this.EditorCommonTextChangedEvent);
            // 
            // button_RegisterPatient
            // 
            this.button_RegisterPatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_RegisterPatient.Location = new System.Drawing.Point(21, 37);
            this.button_RegisterPatient.Name = "button_RegisterPatient";
            this.button_RegisterPatient.Size = new System.Drawing.Size(100, 32);
            this.button_RegisterPatient.TabIndex = 0;
            this.button_RegisterPatient.Text = "환자 등록";
            this.button_RegisterPatient.UseVisualStyleBackColor = true;
            this.button_RegisterPatient.Click += new System.EventHandler(this.OpenRegisterPatientEvent);
            // 
            // button_SearchPatient
            // 
            this.button_SearchPatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SearchPatient.Location = new System.Drawing.Point(148, 37);
            this.button_SearchPatient.Name = "button_SearchPatient";
            this.button_SearchPatient.Size = new System.Drawing.Size(100, 32);
            this.button_SearchPatient.TabIndex = 1;
            this.button_SearchPatient.Text = "환자 검색";
            this.button_SearchPatient.UseVisualStyleBackColor = true;
            this.button_SearchPatient.Click += new System.EventHandler(this.OpenSearchPatientEvent);
            // 
            // button_ManagePayment
            // 
            this.button_ManagePayment.Font = new System.Drawing.Font("굴림", 14F);
            this.button_ManagePayment.Location = new System.Drawing.Point(273, 37);
            this.button_ManagePayment.Name = "button_ManagePayment";
            this.button_ManagePayment.Size = new System.Drawing.Size(100, 32);
            this.button_ManagePayment.TabIndex = 2;
            this.button_ManagePayment.Text = "수납 관리";
            this.button_ManagePayment.UseVisualStyleBackColor = true;
            this.button_ManagePayment.Click += new System.EventHandler(this.OpenPaymentManagementEvent);
            // 
            // labelDivider1
            // 
            this.labelDivider1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.labelDivider1.Location = new System.Drawing.Point(11, 81);
            this.labelDivider1.Name = "labelDivider1";
            this.labelDivider1.Size = new System.Drawing.Size(500, 2);
            this.labelDivider1.TabIndex = 7;
            // 
            // label10
            // 
            this.label10.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label10.Location = new System.Drawing.Point(11, 383);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(500, 2);
            this.label10.TabIndex = 7;
            // 
            // button_SavePatient
            // 
            this.button_SavePatient.Enabled = false;
            this.button_SavePatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SavePatient.Location = new System.Drawing.Point(398, 340);
            this.button_SavePatient.Name = "button_SavePatient";
            this.button_SavePatient.Size = new System.Drawing.Size(100, 32);
            this.button_SavePatient.TabIndex = 14;
            this.button_SavePatient.Text = "정보 저장";
            this.button_SavePatient.UseVisualStyleBackColor = true;
            this.button_SavePatient.Click += new System.EventHandler(this.button_SavePatient_Click);
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("굴림", 14F);
            this.label11.Location = new System.Drawing.Point(17, 396);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(91, 19);
            this.label11.TabIndex = 2;
            this.label11.Text = "진료 접수";
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(21, 429);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(80, 26);
            this.label12.TabIndex = 3;
            this.label12.Text = "환자상태";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientStatus
            // 
            this.textBox_PatientStatus.Enabled = false;
            this.textBox_PatientStatus.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientStatus.Location = new System.Drawing.Point(107, 429);
            this.textBox_PatientStatus.Multiline = true;
            this.textBox_PatientStatus.Name = "textBox_PatientStatus";
            this.textBox_PatientStatus.Size = new System.Drawing.Size(391, 73);
            this.textBox_PatientStatus.TabIndex = 15;
            // 
            // button_RegisterDiagnosis
            // 
            this.button_RegisterDiagnosis.Enabled = false;
            this.button_RegisterDiagnosis.Font = new System.Drawing.Font("굴림", 14F);
            this.button_RegisterDiagnosis.Location = new System.Drawing.Point(398, 508);
            this.button_RegisterDiagnosis.Name = "button_RegisterDiagnosis";
            this.button_RegisterDiagnosis.Size = new System.Drawing.Size(100, 32);
            this.button_RegisterDiagnosis.TabIndex = 16;
            this.button_RegisterDiagnosis.Text = "진료 접수";
            this.button_RegisterDiagnosis.UseVisualStyleBackColor = true;
            this.button_RegisterDiagnosis.Click += new System.EventHandler(this.button_RegisterDiagnosis_Click);
            // 
            // label13
            // 
            this.label13.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label13.Location = new System.Drawing.Point(520, 38);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(2, 500);
            this.label13.TabIndex = 9;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("굴림", 14F);
            this.label14.Location = new System.Drawing.Point(538, 44);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(179, 19);
            this.label14.TabIndex = 2;
            this.label14.Text = "금일 진료 접수 기록";
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToAddRows = false;
            this.dataGridView1.AllowUserToDeleteRows = false;
            this.dataGridView1.AllowUserToResizeColumns = false;
            this.dataGridView1.AllowUserToResizeRows = false;
            this.dataGridView1.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dataGridView1.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.AllCells;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Location = new System.Drawing.Point(542, 75);
            this.dataGridView1.MultiSelect = false;
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.ReadOnly = true;
            this.dataGridView1.RowHeadersVisible = false;
            this.dataGridView1.RowTemplate.Height = 23;
            this.dataGridView1.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dataGridView1.Size = new System.Drawing.Size(643, 463);
            this.dataGridView1.TabIndex = 17;
            this.dataGridView1.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dataGridView1_CellDoubleClick);
            // 
            // button_ViewDiagnosisRecords
            // 
            this.button_ViewDiagnosisRecords.Font = new System.Drawing.Font("굴림", 14F);
            this.button_ViewDiagnosisRecords.Location = new System.Drawing.Point(398, 37);
            this.button_ViewDiagnosisRecords.Name = "button_ViewDiagnosisRecords";
            this.button_ViewDiagnosisRecords.Size = new System.Drawing.Size(100, 32);
            this.button_ViewDiagnosisRecords.TabIndex = 3;
            this.button_ViewDiagnosisRecords.Text = "진료 기록";
            this.button_ViewDiagnosisRecords.UseVisualStyleBackColor = true;
            this.button_ViewDiagnosisRecords.Click += new System.EventHandler(this.button_ViewDiagnosisRecords_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1199, 552);
            this.Controls.Add(this.dataGridView1);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.button_RegisterDiagnosis);
            this.Controls.Add(this.button_SavePatient);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.labelDivider1);
            this.Controls.Add(this.button_ViewDiagnosisRecords);
            this.Controls.Add(this.button_ManagePayment);
            this.Controls.Add(this.button_SearchPatient);
            this.Controls.Add(this.button_RegisterPatient);
            this.Controls.Add(this.textBox_PatientTel);
            this.Controls.Add(this.textBox_PatientID);
            this.Controls.Add(this.textBox_PatientMobile);
            this.Controls.Add(this.textBox_PatientName);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox_PatientJuminNo2);
            this.Controls.Add(this.textBox_PatientAgeSex);
            this.Controls.Add(this.textBox_PatientBirthDate);
            this.Controls.Add(this.textBox_PatientStatus);
            this.Controls.Add(this.textBox_PatientNote);
            this.Controls.Add(this.textBox_PatientAddress);
            this.Controls.Add(this.textBox_PatientJuminNo1);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label14);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.menuStrip1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.Text = "ClinicHelper - Front";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox textBox_PatientJuminNo1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBox_PatientID;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBox_PatientName;
        private System.Windows.Forms.TextBox textBox_PatientJuminNo2;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox textBox_PatientBirthDate;
        private System.Windows.Forms.TextBox textBox_PatientAgeSex;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.TextBox textBox_PatientMobile;
        private System.Windows.Forms.TextBox textBox_PatientTel;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.TextBox textBox_PatientNote;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.TextBox textBox_PatientAddress;
        private System.Windows.Forms.Button button_RegisterPatient;
        private System.Windows.Forms.Button button_SearchPatient;
        private System.Windows.Forms.Button button_ManagePayment;
        private System.Windows.Forms.Label labelDivider1;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Button button_SavePatient;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.TextBox textBox_PatientStatus;
        private System.Windows.Forms.Button button_RegisterDiagnosis;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.DataGridView dataGridView1;
        private System.Windows.Forms.ToolStripMenuItem 환자관리ToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_RegisterPatient;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_SearchPatient;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_PaymentManagement;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_BaseDataManagement;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_ManageDiseaseData;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_ManageMedicineData;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_ManageTreatmentData;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_StatisticData;
        private System.Windows.Forms.Button button_ViewDiagnosisRecords;
    }
}

