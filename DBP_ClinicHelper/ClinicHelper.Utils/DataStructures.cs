using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ClinicHelper.Utils
{
    public struct DiseaseData
    {
        public string KCDCode;
        public string Name;
        public int DiagnosisCost;
    }

    public struct MedicineData
    {
        public int Code;
        public string Name;
    }

    public struct TreatmentData
    {
        public int Code;
        public string Name;
        public int UnitCost;
    }

    public struct PatientData
    {
        public int PatientID;
        public string Name;
        public string JoominNum;
        public string Address;
        public string Telephone;
        public string Mobile;
        public string Note;
    }

    public struct DiagnosisRegistrationData {
        public int RegistrationID;
        public int PatientID;
        public DateTime RegisterDateTime;
        public string PatientStatus;
        public bool DiagnosisDone;
    }

    public struct DiagnosisRecordData
    {
        public int RegistrationID;
        public DateTime DiagnosisDateTime;
        public string KCDCode;
        public string DoctorComment;
        public string DoctorName;
        public string ClinicName;
    }

    public struct MedicinePrescriptionData
    {
        public int MedicineCode;
        public string MedicineName;
        public int SingleDose;
        public int DailyDose;
        public int TotalAmount;
    }
    
    public struct TreatmentPrescriptionData
    {
        public int TreatmentCode;
        public string TreatmentName;
        public int TotalCount;
    }

    public struct PaymentData
    {
        public int RegistrationID;
        public int TotalDiagnosisCost;
        public int TotalTreatmentCost;
        public bool PaymentDone;
    }
}
