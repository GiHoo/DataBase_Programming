namespace ClinicHelper.DoctorApp
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
            this.ToolStripMenu_환자조회 = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenu_진료대기조회 = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_질병검색 = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_약품검색 = new System.Windows.Forms.ToolStripMenuItem();
            this.ToolStripMenuItem_의료행위검색 = new System.Windows.Forms.ToolStripMenuItem();
            this.textBox_PatientTel = new System.Windows.Forms.TextBox();
            this.textBox_PatientID = new System.Windows.Forms.TextBox();
            this.textBox_PatientMobile = new System.Windows.Forms.TextBox();
            this.textBox_PatientName = new System.Windows.Forms.TextBox();
            this.label9 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.textBox_PatientJuminNo2 = new System.Windows.Forms.TextBox();
            this.textBox_PatientAgeSex = new System.Windows.Forms.TextBox();
            this.textBox_PatientBirthDate = new System.Windows.Forms.TextBox();
            this.textBox_PatientNote = new System.Windows.Forms.TextBox();
            this.textBox_PatientAddress = new System.Windows.Forms.TextBox();
            this.textBox_PatientJuminNo1 = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.labelDivider1 = new System.Windows.Forms.Label();
            this.button_SearchPatient = new System.Windows.Forms.Button();
            this.button_RegisterPatient = new System.Windows.Forms.Button();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.textBox_KCDCode = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            this.textBox_DoctorComment = new System.Windows.Forms.TextBox();
            this.button_SearchKCDCode = new System.Windows.Forms.Button();
            this.textBox_PatientStatus = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.textBox_RegisterDateTime = new System.Windows.Forms.TextBox();
            this.label16 = new System.Windows.Forms.Label();
            this.listView1 = new System.Windows.Forms.ListView();
            this.columnHeader1 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader7 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader2 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader3 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader4 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.label22 = new System.Windows.Forms.Label();
            this.label17 = new System.Windows.Forms.Label();
            this.label18 = new System.Windows.Forms.Label();
            this.listView2 = new System.Windows.Forms.ListView();
            this.columnHeader5 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader8 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.columnHeader6 = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.label19 = new System.Windows.Forms.Label();
            this.textBox_ClinicName = new System.Windows.Forms.TextBox();
            this.label20 = new System.Windows.Forms.Label();
            this.label21 = new System.Windows.Forms.Label();
            this.textBox_DoctorName = new System.Windows.Forms.TextBox();
            this.button_SaveDiagnosisRecord = new System.Windows.Forms.Button();
            this.button_NaviSearchKCDCode = new System.Windows.Forms.Button();
            this.button_NaviSearchMedicine = new System.Windows.Forms.Button();
            this.button_NaviSearchTreatment = new System.Windows.Forms.Button();
            this.button_AddMedicinePrescription = new System.Windows.Forms.Button();
            this.button_AddTreatmentPrescription = new System.Windows.Forms.Button();
            this.button_ResetUserInput = new System.Windows.Forms.Button();
            this.button_ViewPreviousDiagnosisRecords = new System.Windows.Forms.Button();
            this.menuStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip1
            // 
            this.menuStrip1.BackColor = System.Drawing.SystemColors.ControlLight;
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.ToolStripMenu_환자조회,
            this.ToolStripMenu_진료대기조회,
            this.ToolStripMenuItem_질병검색,
            this.ToolStripMenuItem_약품검색,
            this.ToolStripMenuItem_의료행위검색});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(1031, 24);
            this.menuStrip1.TabIndex = 0;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // ToolStripMenu_환자조회
            // 
            this.ToolStripMenu_환자조회.Name = "ToolStripMenu_환자조회";
            this.ToolStripMenu_환자조회.Size = new System.Drawing.Size(71, 20);
            this.ToolStripMenu_환자조회.Text = "환자 조회";
            this.ToolStripMenu_환자조회.Click += new System.EventHandler(this.ToolStripMenu_환자조회_Click);
            // 
            // ToolStripMenu_진료대기조회
            // 
            this.ToolStripMenu_진료대기조회.Name = "ToolStripMenu_진료대기조회";
            this.ToolStripMenu_진료대기조회.Size = new System.Drawing.Size(99, 20);
            this.ToolStripMenu_진료대기조회.Text = "진료 대기 조회";
            this.ToolStripMenu_진료대기조회.Click += new System.EventHandler(this.ToolStripMenu_진료대기조회_Click);
            // 
            // ToolStripMenuItem_질병검색
            // 
            this.ToolStripMenuItem_질병검색.Name = "ToolStripMenuItem_질병검색";
            this.ToolStripMenuItem_질병검색.Size = new System.Drawing.Size(71, 20);
            this.ToolStripMenuItem_질병검색.Text = "질병 검색";
            this.ToolStripMenuItem_질병검색.Click += new System.EventHandler(this.ToolStripMenuItem_질병검색_Click);
            // 
            // ToolStripMenuItem_약품검색
            // 
            this.ToolStripMenuItem_약품검색.Name = "ToolStripMenuItem_약품검색";
            this.ToolStripMenuItem_약품검색.Size = new System.Drawing.Size(71, 20);
            this.ToolStripMenuItem_약품검색.Text = "약품 검색";
            this.ToolStripMenuItem_약품검색.Click += new System.EventHandler(this.ToolStripMenuItem_약품검색_Click);
            // 
            // ToolStripMenuItem_의료행위검색
            // 
            this.ToolStripMenuItem_의료행위검색.Name = "ToolStripMenuItem_의료행위검색";
            this.ToolStripMenuItem_의료행위검색.Size = new System.Drawing.Size(99, 20);
            this.ToolStripMenuItem_의료행위검색.Text = "의료 행위 검색";
            this.ToolStripMenuItem_의료행위검색.Click += new System.EventHandler(this.ToolStripMenuItem_의료행위검색_Click);
            // 
            // textBox_PatientTel
            // 
            this.textBox_PatientTel.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientTel.Location = new System.Drawing.Point(352, 131);
            this.textBox_PatientTel.Name = "textBox_PatientTel";
            this.textBox_PatientTel.ReadOnly = true;
            this.textBox_PatientTel.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientTel.TabIndex = 27;
            // 
            // textBox_PatientID
            // 
            this.textBox_PatientID.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientID.Location = new System.Drawing.Point(106, 131);
            this.textBox_PatientID.Name = "textBox_PatientID";
            this.textBox_PatientID.ReadOnly = true;
            this.textBox_PatientID.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientID.TabIndex = 23;
            // 
            // textBox_PatientMobile
            // 
            this.textBox_PatientMobile.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientMobile.Location = new System.Drawing.Point(352, 164);
            this.textBox_PatientMobile.Name = "textBox_PatientMobile";
            this.textBox_PatientMobile.ReadOnly = true;
            this.textBox_PatientMobile.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientMobile.TabIndex = 28;
            // 
            // textBox_PatientName
            // 
            this.textBox_PatientName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientName.Location = new System.Drawing.Point(106, 164);
            this.textBox_PatientName.Name = "textBox_PatientName";
            this.textBox_PatientName.ReadOnly = true;
            this.textBox_PatientName.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientName.TabIndex = 24;
            // 
            // label9
            // 
            this.label9.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label9.Font = new System.Drawing.Font("굴림", 12F);
            this.label9.Location = new System.Drawing.Point(266, 164);
            this.label9.Name = "label9";
            this.label9.Padding = new System.Windows.Forms.Padding(3);
            this.label9.Size = new System.Drawing.Size(80, 26);
            this.label9.TabIndex = 16;
            this.label9.Text = "이동전화";
            this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label4
            // 
            this.label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label4.Font = new System.Drawing.Font("굴림", 12F);
            this.label4.Location = new System.Drawing.Point(20, 164);
            this.label4.Name = "label4";
            this.label4.Padding = new System.Windows.Forms.Padding(3);
            this.label4.Size = new System.Drawing.Size(80, 26);
            this.label4.TabIndex = 17;
            this.label4.Text = "환자명";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientJuminNo2
            // 
            this.textBox_PatientJuminNo2.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo2.Location = new System.Drawing.Point(178, 197);
            this.textBox_PatientJuminNo2.Name = "textBox_PatientJuminNo2";
            this.textBox_PatientJuminNo2.ReadOnly = true;
            this.textBox_PatientJuminNo2.Size = new System.Drawing.Size(73, 26);
            this.textBox_PatientJuminNo2.TabIndex = 26;
            // 
            // textBox_PatientAgeSex
            // 
            this.textBox_PatientAgeSex.Enabled = false;
            this.textBox_PatientAgeSex.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAgeSex.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientAgeSex.Location = new System.Drawing.Point(450, 197);
            this.textBox_PatientAgeSex.Name = "textBox_PatientAgeSex";
            this.textBox_PatientAgeSex.ReadOnly = true;
            this.textBox_PatientAgeSex.Size = new System.Drawing.Size(47, 26);
            this.textBox_PatientAgeSex.TabIndex = 30;
            // 
            // textBox_PatientBirthDate
            // 
            this.textBox_PatientBirthDate.Enabled = false;
            this.textBox_PatientBirthDate.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientBirthDate.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientBirthDate.Location = new System.Drawing.Point(352, 197);
            this.textBox_PatientBirthDate.Name = "textBox_PatientBirthDate";
            this.textBox_PatientBirthDate.ReadOnly = true;
            this.textBox_PatientBirthDate.Size = new System.Drawing.Size(92, 26);
            this.textBox_PatientBirthDate.TabIndex = 29;
            // 
            // textBox_PatientNote
            // 
            this.textBox_PatientNote.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientNote.Location = new System.Drawing.Point(106, 263);
            this.textBox_PatientNote.Multiline = true;
            this.textBox_PatientNote.Name = "textBox_PatientNote";
            this.textBox_PatientNote.ReadOnly = true;
            this.textBox_PatientNote.Size = new System.Drawing.Size(391, 73);
            this.textBox_PatientNote.TabIndex = 32;
            // 
            // textBox_PatientAddress
            // 
            this.textBox_PatientAddress.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAddress.Location = new System.Drawing.Point(106, 230);
            this.textBox_PatientAddress.Name = "textBox_PatientAddress";
            this.textBox_PatientAddress.ReadOnly = true;
            this.textBox_PatientAddress.Size = new System.Drawing.Size(391, 26);
            this.textBox_PatientAddress.TabIndex = 31;
            // 
            // textBox_PatientJuminNo1
            // 
            this.textBox_PatientJuminNo1.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo1.Location = new System.Drawing.Point(106, 197);
            this.textBox_PatientJuminNo1.Name = "textBox_PatientJuminNo1";
            this.textBox_PatientJuminNo1.ReadOnly = true;
            this.textBox_PatientJuminNo1.Size = new System.Drawing.Size(66, 26);
            this.textBox_PatientJuminNo1.TabIndex = 25;
            // 
            // label5
            // 
            this.label5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label5.Font = new System.Drawing.Font("굴림", 12F);
            this.label5.Location = new System.Drawing.Point(266, 197);
            this.label5.Name = "label5";
            this.label5.Padding = new System.Windows.Forms.Padding(3);
            this.label5.Size = new System.Drawing.Size(80, 26);
            this.label5.TabIndex = 22;
            this.label5.Text = "생년월일";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label7
            // 
            this.label7.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label7.Font = new System.Drawing.Font("굴림", 12F);
            this.label7.Location = new System.Drawing.Point(20, 263);
            this.label7.Name = "label7";
            this.label7.Padding = new System.Windows.Forms.Padding(3);
            this.label7.Size = new System.Drawing.Size(80, 26);
            this.label7.TabIndex = 21;
            this.label7.Text = "비고";
            this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label8
            // 
            this.label8.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label8.Font = new System.Drawing.Font("굴림", 12F);
            this.label8.Location = new System.Drawing.Point(20, 230);
            this.label8.Name = "label8";
            this.label8.Padding = new System.Windows.Forms.Padding(3);
            this.label8.Size = new System.Drawing.Size(80, 26);
            this.label8.TabIndex = 19;
            this.label8.Text = "주소지";
            this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label3
            // 
            this.label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label3.Font = new System.Drawing.Font("굴림", 12F);
            this.label3.Location = new System.Drawing.Point(20, 197);
            this.label3.Name = "label3";
            this.label3.Padding = new System.Windows.Forms.Padding(3);
            this.label3.Size = new System.Drawing.Size(80, 26);
            this.label3.TabIndex = 18;
            this.label3.Text = "주민번호";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label6
            // 
            this.label6.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label6.Font = new System.Drawing.Font("굴림", 12F);
            this.label6.Location = new System.Drawing.Point(266, 131);
            this.label6.Name = "label6";
            this.label6.Padding = new System.Windows.Forms.Padding(3);
            this.label6.Size = new System.Drawing.Size(80, 26);
            this.label6.TabIndex = 15;
            this.label6.Text = "유선전화";
            this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label2
            // 
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Font = new System.Drawing.Font("굴림", 12F);
            this.label2.Location = new System.Drawing.Point(20, 131);
            this.label2.Name = "label2";
            this.label2.Padding = new System.Windows.Forms.Padding(3);
            this.label2.Size = new System.Drawing.Size(80, 26);
            this.label2.TabIndex = 20;
            this.label2.Text = "환자 ID";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14F);
            this.label1.Location = new System.Drawing.Point(16, 96);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(91, 19);
            this.label1.TabIndex = 14;
            this.label1.Text = "환자 정보";
            // 
            // labelDivider1
            // 
            this.labelDivider1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.labelDivider1.Location = new System.Drawing.Point(10, 84);
            this.labelDivider1.Name = "labelDivider1";
            this.labelDivider1.Size = new System.Drawing.Size(1010, 2);
            this.labelDivider1.TabIndex = 35;
            // 
            // button_SearchPatient
            // 
            this.button_SearchPatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SearchPatient.Location = new System.Drawing.Point(194, 40);
            this.button_SearchPatient.Name = "button_SearchPatient";
            this.button_SearchPatient.Size = new System.Drawing.Size(100, 32);
            this.button_SearchPatient.TabIndex = 10;
            this.button_SearchPatient.Text = "환자 검색";
            this.button_SearchPatient.UseVisualStyleBackColor = true;
            this.button_SearchPatient.Click += new System.EventHandler(this.button_SearchPatient_Click);
            // 
            // button_RegisterPatient
            // 
            this.button_RegisterPatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_RegisterPatient.Location = new System.Drawing.Point(20, 40);
            this.button_RegisterPatient.Name = "button_RegisterPatient";
            this.button_RegisterPatient.Size = new System.Drawing.Size(152, 32);
            this.button_RegisterPatient.TabIndex = 9;
            this.button_RegisterPatient.Text = "진료 대기 조회";
            this.button_RegisterPatient.UseVisualStyleBackColor = true;
            this.button_RegisterPatient.Click += new System.EventHandler(this.button_RegisterPatient_Click);
            // 
            // label10
            // 
            this.label10.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label10.Location = new System.Drawing.Point(10, 348);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(500, 2);
            this.label10.TabIndex = 35;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("굴림", 14F);
            this.label11.Location = new System.Drawing.Point(16, 528);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(91, 19);
            this.label11.TabIndex = 14;
            this.label11.Text = "진료 정보";
            // 
            // label12
            // 
            this.label12.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label12.Font = new System.Drawing.Font("굴림", 12F);
            this.label12.Location = new System.Drawing.Point(20, 561);
            this.label12.Name = "label12";
            this.label12.Padding = new System.Windows.Forms.Padding(3);
            this.label12.Size = new System.Drawing.Size(80, 26);
            this.label12.TabIndex = 20;
            this.label12.Text = "질병코드";
            this.label12.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_KCDCode
            // 
            this.textBox_KCDCode.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_KCDCode.Location = new System.Drawing.Point(106, 561);
            this.textBox_KCDCode.Name = "textBox_KCDCode";
            this.textBox_KCDCode.Size = new System.Drawing.Size(145, 26);
            this.textBox_KCDCode.TabIndex = 0;
            // 
            // label13
            // 
            this.label13.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label13.Font = new System.Drawing.Font("굴림", 12F);
            this.label13.Location = new System.Drawing.Point(20, 593);
            this.label13.Name = "label13";
            this.label13.Padding = new System.Windows.Forms.Padding(3);
            this.label13.Size = new System.Drawing.Size(80, 26);
            this.label13.TabIndex = 21;
            this.label13.Text = "소견";
            this.label13.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_DoctorComment
            // 
            this.textBox_DoctorComment.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_DoctorComment.Location = new System.Drawing.Point(106, 593);
            this.textBox_DoctorComment.Multiline = true;
            this.textBox_DoctorComment.Name = "textBox_DoctorComment";
            this.textBox_DoctorComment.Size = new System.Drawing.Size(391, 73);
            this.textBox_DoctorComment.TabIndex = 2;
            // 
            // button_SearchKCDCode
            // 
            this.button_SearchKCDCode.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_SearchKCDCode.Location = new System.Drawing.Point(257, 561);
            this.button_SearchKCDCode.Name = "button_SearchKCDCode";
            this.button_SearchKCDCode.Size = new System.Drawing.Size(125, 26);
            this.button_SearchKCDCode.TabIndex = 1;
            this.button_SearchKCDCode.Text = "질병 코드 검색";
            this.button_SearchKCDCode.UseVisualStyleBackColor = true;
            this.button_SearchKCDCode.Click += new System.EventHandler(this.button_SearchKCDCode_Click);
            // 
            // textBox_PatientStatus
            // 
            this.textBox_PatientStatus.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientStatus.Location = new System.Drawing.Point(106, 428);
            this.textBox_PatientStatus.Multiline = true;
            this.textBox_PatientStatus.Name = "textBox_PatientStatus";
            this.textBox_PatientStatus.ReadOnly = true;
            this.textBox_PatientStatus.Size = new System.Drawing.Size(391, 73);
            this.textBox_PatientStatus.TabIndex = 63;
            // 
            // label14
            // 
            this.label14.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label14.Font = new System.Drawing.Font("굴림", 12F);
            this.label14.Location = new System.Drawing.Point(20, 428);
            this.label14.Name = "label14";
            this.label14.Padding = new System.Windows.Forms.Padding(3);
            this.label14.Size = new System.Drawing.Size(80, 26);
            this.label14.TabIndex = 62;
            this.label14.Text = "환자상태";
            this.label14.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("굴림", 14F);
            this.label15.Location = new System.Drawing.Point(16, 362);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(91, 19);
            this.label15.TabIndex = 61;
            this.label15.Text = "접수 정보";
            // 
            // textBox_RegisterDateTime
            // 
            this.textBox_RegisterDateTime.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_RegisterDateTime.Location = new System.Drawing.Point(106, 396);
            this.textBox_RegisterDateTime.Name = "textBox_RegisterDateTime";
            this.textBox_RegisterDateTime.ReadOnly = true;
            this.textBox_RegisterDateTime.Size = new System.Drawing.Size(240, 26);
            this.textBox_RegisterDateTime.TabIndex = 60;
            // 
            // label16
            // 
            this.label16.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label16.Font = new System.Drawing.Font("굴림", 12F);
            this.label16.Location = new System.Drawing.Point(20, 396);
            this.label16.Name = "label16";
            this.label16.Padding = new System.Windows.Forms.Padding(3);
            this.label16.Size = new System.Drawing.Size(80, 26);
            this.label16.TabIndex = 59;
            this.label16.Text = "접수일시";
            this.label16.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // listView1
            // 
            this.listView1.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader1,
            this.columnHeader7,
            this.columnHeader2,
            this.columnHeader3,
            this.columnHeader4});
            this.listView1.HideSelection = false;
            this.listView1.Location = new System.Drawing.Point(536, 126);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(477, 210);
            this.listView1.TabIndex = 64;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader1
            // 
            this.columnHeader1.Text = "약품 코드";
            this.columnHeader1.Width = 71;
            // 
            // columnHeader7
            // 
            this.columnHeader7.Text = "약품명";
            this.columnHeader7.Width = 132;
            // 
            // columnHeader2
            // 
            this.columnHeader2.Text = "1회 투여량";
            this.columnHeader2.Width = 79;
            // 
            // columnHeader3
            // 
            this.columnHeader3.Text = "1일 투여량";
            this.columnHeader3.Width = 78;
            // 
            // columnHeader4
            // 
            this.columnHeader4.Text = "총 투약 일수";
            this.columnHeader4.Width = 94;
            // 
            // label22
            // 
            this.label22.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label22.Location = new System.Drawing.Point(517, 93);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(2, 580);
            this.label22.TabIndex = 65;
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("굴림", 14F);
            this.label17.Location = new System.Drawing.Point(532, 96);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(135, 19);
            this.label17.TabIndex = 14;
            this.label17.Text = "처방 약품 목록";
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("굴림", 14F);
            this.label18.Location = new System.Drawing.Point(532, 353);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(179, 19);
            this.label18.TabIndex = 14;
            this.label18.Text = "처방 의료 행위 목록";
            // 
            // listView2
            // 
            this.listView2.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.columnHeader5,
            this.columnHeader8,
            this.columnHeader6});
            this.listView2.HideSelection = false;
            this.listView2.Location = new System.Drawing.Point(536, 383);
            this.listView2.Name = "listView2";
            this.listView2.Size = new System.Drawing.Size(477, 210);
            this.listView2.TabIndex = 64;
            this.listView2.UseCompatibleStateImageBehavior = false;
            this.listView2.View = System.Windows.Forms.View.Details;
            // 
            // columnHeader5
            // 
            this.columnHeader5.Text = "행위 코드";
            this.columnHeader5.Width = 71;
            // 
            // columnHeader8
            // 
            this.columnHeader8.Text = "행위명";
            this.columnHeader8.Width = 309;
            // 
            // columnHeader6
            // 
            this.columnHeader6.Text = "총 행위 수";
            this.columnHeader6.Width = 77;
            // 
            // label19
            // 
            this.label19.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label19.Location = new System.Drawing.Point(11, 513);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(500, 2);
            this.label19.TabIndex = 35;
            // 
            // textBox_ClinicName
            // 
            this.textBox_ClinicName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_ClinicName.Location = new System.Drawing.Point(622, 600);
            this.textBox_ClinicName.Name = "textBox_ClinicName";
            this.textBox_ClinicName.Size = new System.Drawing.Size(196, 26);
            this.textBox_ClinicName.TabIndex = 5;
            this.textBox_ClinicName.Text = "두유내과의원";
            // 
            // label20
            // 
            this.label20.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label20.Font = new System.Drawing.Font("굴림", 12F);
            this.label20.Location = new System.Drawing.Point(536, 600);
            this.label20.Name = "label20";
            this.label20.Padding = new System.Windows.Forms.Padding(3);
            this.label20.Size = new System.Drawing.Size(80, 26);
            this.label20.TabIndex = 66;
            this.label20.Text = "의원명";
            this.label20.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label21
            // 
            this.label21.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label21.Font = new System.Drawing.Font("굴림", 12F);
            this.label21.Location = new System.Drawing.Point(824, 600);
            this.label21.Name = "label21";
            this.label21.Padding = new System.Windows.Forms.Padding(3);
            this.label21.Size = new System.Drawing.Size(80, 26);
            this.label21.TabIndex = 66;
            this.label21.Text = "의사명";
            this.label21.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_DoctorName
            // 
            this.textBox_DoctorName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_DoctorName.Location = new System.Drawing.Point(910, 600);
            this.textBox_DoctorName.Name = "textBox_DoctorName";
            this.textBox_DoctorName.Size = new System.Drawing.Size(103, 26);
            this.textBox_DoctorName.TabIndex = 6;
            this.textBox_DoctorName.Text = "김두유";
            // 
            // button_SaveDiagnosisRecord
            // 
            this.button_SaveDiagnosisRecord.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_SaveDiagnosisRecord.Location = new System.Drawing.Point(777, 632);
            this.button_SaveDiagnosisRecord.Name = "button_SaveDiagnosisRecord";
            this.button_SaveDiagnosisRecord.Size = new System.Drawing.Size(236, 34);
            this.button_SaveDiagnosisRecord.TabIndex = 8;
            this.button_SaveDiagnosisRecord.Text = "진료 기록 저장";
            this.button_SaveDiagnosisRecord.UseVisualStyleBackColor = true;
            this.button_SaveDiagnosisRecord.Click += new System.EventHandler(this.button_SaveDiagnosisRecord_Click);
            // 
            // button_NaviSearchKCDCode
            // 
            this.button_NaviSearchKCDCode.Font = new System.Drawing.Font("굴림", 14F);
            this.button_NaviSearchKCDCode.Location = new System.Drawing.Point(316, 40);
            this.button_NaviSearchKCDCode.Name = "button_NaviSearchKCDCode";
            this.button_NaviSearchKCDCode.Size = new System.Drawing.Size(146, 32);
            this.button_NaviSearchKCDCode.TabIndex = 11;
            this.button_NaviSearchKCDCode.Text = "질병 코드 조회";
            this.button_NaviSearchKCDCode.UseVisualStyleBackColor = true;
            this.button_NaviSearchKCDCode.Click += new System.EventHandler(this.button_NaviSearchKCDCode_Click);
            // 
            // button_NaviSearchMedicine
            // 
            this.button_NaviSearchMedicine.Font = new System.Drawing.Font("굴림", 14F);
            this.button_NaviSearchMedicine.Location = new System.Drawing.Point(484, 40);
            this.button_NaviSearchMedicine.Name = "button_NaviSearchMedicine";
            this.button_NaviSearchMedicine.Size = new System.Drawing.Size(146, 32);
            this.button_NaviSearchMedicine.TabIndex = 12;
            this.button_NaviSearchMedicine.Text = "약품 코드 조회";
            this.button_NaviSearchMedicine.UseVisualStyleBackColor = true;
            this.button_NaviSearchMedicine.Click += new System.EventHandler(this.button_NaviSearchMedicine_Click);
            // 
            // button_NaviSearchTreatment
            // 
            this.button_NaviSearchTreatment.Font = new System.Drawing.Font("굴림", 14F);
            this.button_NaviSearchTreatment.Location = new System.Drawing.Point(652, 40);
            this.button_NaviSearchTreatment.Name = "button_NaviSearchTreatment";
            this.button_NaviSearchTreatment.Size = new System.Drawing.Size(146, 32);
            this.button_NaviSearchTreatment.TabIndex = 13;
            this.button_NaviSearchTreatment.Text = "행위 코드 조회";
            this.button_NaviSearchTreatment.UseVisualStyleBackColor = true;
            this.button_NaviSearchTreatment.Click += new System.EventHandler(this.button_NaviSearchTreatment_Click);
            // 
            // button_AddMedicinePrescription
            // 
            this.button_AddMedicinePrescription.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_AddMedicinePrescription.Location = new System.Drawing.Point(989, 93);
            this.button_AddMedicinePrescription.Name = "button_AddMedicinePrescription";
            this.button_AddMedicinePrescription.Size = new System.Drawing.Size(24, 27);
            this.button_AddMedicinePrescription.TabIndex = 3;
            this.button_AddMedicinePrescription.Text = "+";
            this.button_AddMedicinePrescription.UseVisualStyleBackColor = true;
            this.button_AddMedicinePrescription.Click += new System.EventHandler(this.button_AddMedicinePrescription_Click);
            // 
            // button_AddTreatmentPrescription
            // 
            this.button_AddTreatmentPrescription.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_AddTreatmentPrescription.Location = new System.Drawing.Point(989, 350);
            this.button_AddTreatmentPrescription.Name = "button_AddTreatmentPrescription";
            this.button_AddTreatmentPrescription.Size = new System.Drawing.Size(24, 27);
            this.button_AddTreatmentPrescription.TabIndex = 4;
            this.button_AddTreatmentPrescription.Text = "+";
            this.button_AddTreatmentPrescription.UseVisualStyleBackColor = true;
            this.button_AddTreatmentPrescription.Click += new System.EventHandler(this.button_AddTreatmentPrescription_Click);
            // 
            // button_ResetUserInput
            // 
            this.button_ResetUserInput.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_ResetUserInput.ForeColor = System.Drawing.Color.Red;
            this.button_ResetUserInput.Location = new System.Drawing.Point(536, 632);
            this.button_ResetUserInput.Name = "button_ResetUserInput";
            this.button_ResetUserInput.Size = new System.Drawing.Size(236, 34);
            this.button_ResetUserInput.TabIndex = 7;
            this.button_ResetUserInput.Text = "입력 내용 초기화";
            this.button_ResetUserInput.UseVisualStyleBackColor = true;
            this.button_ResetUserInput.Click += new System.EventHandler(this.button_ResetUserInput_Click);
            // 
            // button_ViewPreviousDiagnosisRecords
            // 
            this.button_ViewPreviousDiagnosisRecords.Font = new System.Drawing.Font("굴림", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.button_ViewPreviousDiagnosisRecords.Location = new System.Drawing.Point(339, 94);
            this.button_ViewPreviousDiagnosisRecords.Name = "button_ViewPreviousDiagnosisRecords";
            this.button_ViewPreviousDiagnosisRecords.Size = new System.Drawing.Size(158, 26);
            this.button_ViewPreviousDiagnosisRecords.TabIndex = 1;
            this.button_ViewPreviousDiagnosisRecords.Text = "이전 진료 기록 조회";
            this.button_ViewPreviousDiagnosisRecords.UseVisualStyleBackColor = true;
            this.button_ViewPreviousDiagnosisRecords.Click += new System.EventHandler(this.button_ViewPreviousDiagnosisRecords_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1031, 682);
            this.Controls.Add(this.button_ResetUserInput);
            this.Controls.Add(this.button_SaveDiagnosisRecord);
            this.Controls.Add(this.textBox_DoctorName);
            this.Controls.Add(this.label21);
            this.Controls.Add(this.textBox_ClinicName);
            this.Controls.Add(this.label20);
            this.Controls.Add(this.label22);
            this.Controls.Add(this.listView2);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.textBox_PatientStatus);
            this.Controls.Add(this.label14);
            this.Controls.Add(this.label15);
            this.Controls.Add(this.textBox_RegisterDateTime);
            this.Controls.Add(this.label16);
            this.Controls.Add(this.button_ViewPreviousDiagnosisRecords);
            this.Controls.Add(this.button_SearchKCDCode);
            this.Controls.Add(this.label19);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.labelDivider1);
            this.Controls.Add(this.button_NaviSearchTreatment);
            this.Controls.Add(this.button_NaviSearchMedicine);
            this.Controls.Add(this.button_AddTreatmentPrescription);
            this.Controls.Add(this.button_AddMedicinePrescription);
            this.Controls.Add(this.button_NaviSearchKCDCode);
            this.Controls.Add(this.button_SearchPatient);
            this.Controls.Add(this.button_RegisterPatient);
            this.Controls.Add(this.textBox_PatientTel);
            this.Controls.Add(this.textBox_KCDCode);
            this.Controls.Add(this.textBox_PatientID);
            this.Controls.Add(this.textBox_PatientMobile);
            this.Controls.Add(this.textBox_PatientName);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox_PatientJuminNo2);
            this.Controls.Add(this.textBox_PatientAgeSex);
            this.Controls.Add(this.textBox_PatientBirthDate);
            this.Controls.Add(this.textBox_DoctorComment);
            this.Controls.Add(this.textBox_PatientNote);
            this.Controls.Add(this.textBox_PatientAddress);
            this.Controls.Add(this.textBox_PatientJuminNo1);
            this.Controls.Add(this.label13);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label12);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label18);
            this.Controls.Add(this.label11);
            this.Controls.Add(this.label17);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.menuStrip1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.Name = "MainForm";
            this.ShowIcon = false;
            this.Text = "ClinicHelper - DoctorApp";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenu_환자조회;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenu_진료대기조회;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_질병검색;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_약품검색;
        private System.Windows.Forms.ToolStripMenuItem ToolStripMenuItem_의료행위검색;
        private System.Windows.Forms.TextBox textBox_PatientTel;
        private System.Windows.Forms.TextBox textBox_PatientID;
        private System.Windows.Forms.TextBox textBox_PatientMobile;
        private System.Windows.Forms.TextBox textBox_PatientName;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox textBox_PatientJuminNo2;
        private System.Windows.Forms.TextBox textBox_PatientAgeSex;
        private System.Windows.Forms.TextBox textBox_PatientBirthDate;
        private System.Windows.Forms.TextBox textBox_PatientNote;
        private System.Windows.Forms.TextBox textBox_PatientAddress;
        private System.Windows.Forms.TextBox textBox_PatientJuminNo1;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label labelDivider1;
        private System.Windows.Forms.Button button_SearchPatient;
        private System.Windows.Forms.Button button_RegisterPatient;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.TextBox textBox_KCDCode;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.TextBox textBox_DoctorComment;
        private System.Windows.Forms.Button button_SearchKCDCode;
        private System.Windows.Forms.TextBox textBox_PatientStatus;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox textBox_RegisterDateTime;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.ListView listView1;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.ListView listView2;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.TextBox textBox_ClinicName;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox textBox_DoctorName;
        private System.Windows.Forms.Button button_SaveDiagnosisRecord;
        private System.Windows.Forms.Button button_NaviSearchKCDCode;
        private System.Windows.Forms.Button button_NaviSearchMedicine;
        private System.Windows.Forms.Button button_NaviSearchTreatment;
        private System.Windows.Forms.Button button_AddMedicinePrescription;
        private System.Windows.Forms.Button button_AddTreatmentPrescription;
        private System.Windows.Forms.Button button_ResetUserInput;
        private System.Windows.Forms.ColumnHeader columnHeader1;
        private System.Windows.Forms.ColumnHeader columnHeader2;
        private System.Windows.Forms.ColumnHeader columnHeader3;
        private System.Windows.Forms.ColumnHeader columnHeader4;
        private System.Windows.Forms.ColumnHeader columnHeader5;
        private System.Windows.Forms.ColumnHeader columnHeader6;
        private System.Windows.Forms.ColumnHeader columnHeader7;
        private System.Windows.Forms.ColumnHeader columnHeader8;
        private System.Windows.Forms.Button button_ViewPreviousDiagnosisRecords;
    }
}

