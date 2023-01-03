namespace ClinicHelper.FrontDeskApp.PatientManagement
{
    partial class PatientRegisterationForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button_SavePatient = new System.Windows.Forms.Button();
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
            this.SuspendLayout();
            // 
            // button_SavePatient
            // 
            this.button_SavePatient.Font = new System.Drawing.Font("굴림", 14F);
            this.button_SavePatient.Location = new System.Drawing.Point(393, 260);
            this.button_SavePatient.Name = "button_SavePatient";
            this.button_SavePatient.Size = new System.Drawing.Size(100, 32);
            this.button_SavePatient.TabIndex = 10;
            this.button_SavePatient.Text = "정보 저장";
            this.button_SavePatient.UseVisualStyleBackColor = true;
            this.button_SavePatient.Click += new System.EventHandler(this.button_SavePatient_Click);
            // 
            // textBox_PatientTel
            // 
            this.textBox_PatientTel.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientTel.Location = new System.Drawing.Point(348, 49);
            this.textBox_PatientTel.Name = "textBox_PatientTel";
            this.textBox_PatientTel.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientTel.TabIndex = 4;
            // 
            // textBox_PatientID
            // 
            this.textBox_PatientID.Enabled = false;
            this.textBox_PatientID.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientID.Location = new System.Drawing.Point(102, 49);
            this.textBox_PatientID.Name = "textBox_PatientID";
            this.textBox_PatientID.ReadOnly = true;
            this.textBox_PatientID.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientID.TabIndex = 0;
            // 
            // textBox_PatientMobile
            // 
            this.textBox_PatientMobile.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientMobile.Location = new System.Drawing.Point(348, 82);
            this.textBox_PatientMobile.Name = "textBox_PatientMobile";
            this.textBox_PatientMobile.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientMobile.TabIndex = 5;
            // 
            // textBox_PatientName
            // 
            this.textBox_PatientName.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientName.Location = new System.Drawing.Point(102, 82);
            this.textBox_PatientName.Name = "textBox_PatientName";
            this.textBox_PatientName.Size = new System.Drawing.Size(145, 26);
            this.textBox_PatientName.TabIndex = 1;
            // 
            // label9
            // 
            this.label9.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label9.Font = new System.Drawing.Font("굴림", 12F);
            this.label9.Location = new System.Drawing.Point(262, 82);
            this.label9.Name = "label9";
            this.label9.Padding = new System.Windows.Forms.Padding(3);
            this.label9.Size = new System.Drawing.Size(80, 26);
            this.label9.TabIndex = 14;
            this.label9.Text = "이동전화";
            this.label9.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label4
            // 
            this.label4.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label4.Font = new System.Drawing.Font("굴림", 12F);
            this.label4.Location = new System.Drawing.Point(16, 82);
            this.label4.Name = "label4";
            this.label4.Padding = new System.Windows.Forms.Padding(3);
            this.label4.Size = new System.Drawing.Size(80, 26);
            this.label4.TabIndex = 15;
            this.label4.Text = "환자명";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // textBox_PatientJuminNo2
            // 
            this.textBox_PatientJuminNo2.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo2.Location = new System.Drawing.Point(174, 115);
            this.textBox_PatientJuminNo2.Name = "textBox_PatientJuminNo2";
            this.textBox_PatientJuminNo2.Size = new System.Drawing.Size(73, 26);
            this.textBox_PatientJuminNo2.TabIndex = 3;
            this.textBox_PatientJuminNo2.TextChanged += new System.EventHandler(this.JuminNumTextChangeEvent);
            // 
            // textBox_PatientAgeSex
            // 
            this.textBox_PatientAgeSex.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAgeSex.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientAgeSex.Location = new System.Drawing.Point(446, 115);
            this.textBox_PatientAgeSex.Name = "textBox_PatientAgeSex";
            this.textBox_PatientAgeSex.ReadOnly = true;
            this.textBox_PatientAgeSex.Size = new System.Drawing.Size(47, 26);
            this.textBox_PatientAgeSex.TabIndex = 7;
            // 
            // textBox_PatientBirthDate
            // 
            this.textBox_PatientBirthDate.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientBirthDate.ImeMode = System.Windows.Forms.ImeMode.NoControl;
            this.textBox_PatientBirthDate.Location = new System.Drawing.Point(348, 115);
            this.textBox_PatientBirthDate.Name = "textBox_PatientBirthDate";
            this.textBox_PatientBirthDate.ReadOnly = true;
            this.textBox_PatientBirthDate.Size = new System.Drawing.Size(92, 26);
            this.textBox_PatientBirthDate.TabIndex = 6;
            // 
            // textBox_PatientNote
            // 
            this.textBox_PatientNote.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientNote.Location = new System.Drawing.Point(102, 181);
            this.textBox_PatientNote.Multiline = true;
            this.textBox_PatientNote.Name = "textBox_PatientNote";
            this.textBox_PatientNote.Size = new System.Drawing.Size(391, 73);
            this.textBox_PatientNote.TabIndex = 9;
            // 
            // textBox_PatientAddress
            // 
            this.textBox_PatientAddress.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientAddress.Location = new System.Drawing.Point(102, 148);
            this.textBox_PatientAddress.Name = "textBox_PatientAddress";
            this.textBox_PatientAddress.Size = new System.Drawing.Size(391, 26);
            this.textBox_PatientAddress.TabIndex = 8;
            // 
            // textBox_PatientJuminNo1
            // 
            this.textBox_PatientJuminNo1.Font = new System.Drawing.Font("굴림", 12F);
            this.textBox_PatientJuminNo1.Location = new System.Drawing.Point(102, 115);
            this.textBox_PatientJuminNo1.Name = "textBox_PatientJuminNo1";
            this.textBox_PatientJuminNo1.Size = new System.Drawing.Size(66, 26);
            this.textBox_PatientJuminNo1.TabIndex = 2;
            this.textBox_PatientJuminNo1.TextChanged += new System.EventHandler(this.JuminNumTextChangeEvent);
            // 
            // label5
            // 
            this.label5.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label5.Font = new System.Drawing.Font("굴림", 12F);
            this.label5.Location = new System.Drawing.Point(262, 115);
            this.label5.Name = "label5";
            this.label5.Padding = new System.Windows.Forms.Padding(3);
            this.label5.Size = new System.Drawing.Size(80, 26);
            this.label5.TabIndex = 16;
            this.label5.Text = "생년월일";
            this.label5.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label7
            // 
            this.label7.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label7.Font = new System.Drawing.Font("굴림", 12F);
            this.label7.Location = new System.Drawing.Point(16, 181);
            this.label7.Name = "label7";
            this.label7.Padding = new System.Windows.Forms.Padding(3);
            this.label7.Size = new System.Drawing.Size(80, 26);
            this.label7.TabIndex = 13;
            this.label7.Text = "비고";
            this.label7.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label8
            // 
            this.label8.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label8.Font = new System.Drawing.Font("굴림", 12F);
            this.label8.Location = new System.Drawing.Point(16, 148);
            this.label8.Name = "label8";
            this.label8.Padding = new System.Windows.Forms.Padding(3);
            this.label8.Size = new System.Drawing.Size(80, 26);
            this.label8.TabIndex = 12;
            this.label8.Text = "주소지";
            this.label8.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label3
            // 
            this.label3.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label3.Font = new System.Drawing.Font("굴림", 12F);
            this.label3.Location = new System.Drawing.Point(16, 115);
            this.label3.Name = "label3";
            this.label3.Padding = new System.Windows.Forms.Padding(3);
            this.label3.Size = new System.Drawing.Size(80, 26);
            this.label3.TabIndex = 11;
            this.label3.Text = "주민번호";
            this.label3.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label6
            // 
            this.label6.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label6.Font = new System.Drawing.Font("굴림", 12F);
            this.label6.Location = new System.Drawing.Point(262, 49);
            this.label6.Name = "label6";
            this.label6.Padding = new System.Windows.Forms.Padding(3);
            this.label6.Size = new System.Drawing.Size(80, 26);
            this.label6.TabIndex = 10;
            this.label6.Text = "유선전화";
            this.label6.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label2
            // 
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Font = new System.Drawing.Font("굴림", 12F);
            this.label2.Location = new System.Drawing.Point(16, 49);
            this.label2.Name = "label2";
            this.label2.Padding = new System.Windows.Forms.Padding(3);
            this.label2.Size = new System.Drawing.Size(80, 26);
            this.label2.TabIndex = 17;
            this.label2.Text = "환자 ID";
            this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("굴림", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(129)));
            this.label1.Location = new System.Drawing.Point(12, 14);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(96, 19);
            this.label1.TabIndex = 9;
            this.label1.Text = "환자 등록";
            // 
            // PatientRegisterationForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(507, 304);
            this.Controls.Add(this.button_SavePatient);
            this.Controls.Add(this.textBox_PatientTel);
            this.Controls.Add(this.textBox_PatientID);
            this.Controls.Add(this.textBox_PatientMobile);
            this.Controls.Add(this.textBox_PatientName);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.textBox_PatientJuminNo2);
            this.Controls.Add(this.textBox_PatientAgeSex);
            this.Controls.Add(this.textBox_PatientBirthDate);
            this.Controls.Add(this.textBox_PatientNote);
            this.Controls.Add(this.textBox_PatientAddress);
            this.Controls.Add(this.textBox_PatientJuminNo1);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "PatientRegisterationForm";
            this.Text = "환자 등록";
            this.KeyUp += new System.Windows.Forms.KeyEventHandler(this.PatientRegisterationForm_KeyUp);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button_SavePatient;
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
    }
}