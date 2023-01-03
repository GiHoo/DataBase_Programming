DROP TABLE payment_info;
DROP TABLE prescribed_medicines;
DROP TABLE prescribed_treatments;
DROP TABLE diagnosis_record;
DROP TABLE disease_info;
DROP TABLE medicine_info;
DROP TABLE treatment_info;
DROP TABLE diagnosis_registration;
DROP TABLE patient_info;

DROP SEQUENCE PATIENT_ID_SEQ;
DROP SEQUENCE REGISTRATION_ID_SEQ;


-- 환자 정보
CREATE SEQUENCE PATIENT_ID_SEQ
INCREMENT BY 1
START WITH 1;

CREATE TABLE patient_info
(
patient_id    INTEGER NOT NULL,
patient_name    VARCHAR2(20) NOT NULL,
joomin_num    VARCHAR2(15) NOT NULL,
address    VARCHAR2(30) NOT NULL,
telephone    VARCHAR2(15) NOT NULL,
mobile    VARCHAR2(15) NOT NULL,
note    VARCHAR2(100),
CONSTRAINT patient_info_PK PRIMARY KEY ( patient_id )
);


-- 진료 접수 정보
CREATE SEQUENCE REGISTRATION_ID_SEQ
INCREMENT BY 1
START WITH 1;

CREATE TABLE diagnosis_registration
(
registration_id    INTEGER NOT NULL,
patient_id    INTEGER NOT NULL,
register_datetime    TIMESTAMP NOT NULL,
patient_status   VARCHAR2(100),
diagnosis_done    INTEGER NOT NULL,
CONSTRAINT diagnosis_registration_PK PRIMARY KEY ( registration_id ),
CONSTRAINT diagnosis_registration_FK_PI FOREIGN KEY ( patient_id ) REFERENCES patient_info( patient_id )
);


-- 질병 기초 정보
CREATE TABLE disease_info
(
kcd_code    VARCHAR2(5) NOT NULL,
disease_name    VARCHAR2(60) NOT NULL,
unit_diagnosis_cost    INTEGER NOT NULL,
CONSTRAINT disease_info_PK PRIMARY KEY ( kcd_code )
);

CREATE OR REPLACE PROCEDURE UPSERT_DISEASE_INFO
(
    inputKcdCode disease_info.kcd_code%TYPE,
    inputDiseaseName disease_info.disease_name%TYPE,
    inputUnitCost disease_info.unit_diagnosis_cost%TYPE
)
AS
BEGIN
INSERT INTO
    disease_info (kcd_code, disease_name, unit_diagnosis_cost)
VALUES
    (inputKcdCode, inputDiseaseName, inputUnitCost);
    COMMIT;
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    UPDATE
        disease_info
    SET
        disease_name = inputDiseaseName,
        unit_diagnosis_cost = inputUnitCost
    WHERE
        kcd_code = inputKcdCode;
    COMMIT;
END;
/


-- 의약품 기초 정보
CREATE TABLE medicine_info
(
medicine_code    INTEGER NOT NULL,
medicine_name    VARCHAR2(60) NOT NULL,
CONSTRAINT medicine_info_PK PRIMARY KEY (medicine_code)
);

CREATE OR REPLACE PROCEDURE UPSERT_MEDICINE_INFO
(
    inputCode medicine_info.medicine_code%TYPE,
    inputName medicine_info.medicine_name%TYPE
)
AS
BEGIN
INSERT INTO
    medicine_info (medicine_code, medicine_name)
VALUES
    (inputCode, inputName);
COMMIT;
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    UPDATE
        medicine_info
    SET
        medicine_name = inputName
    WHERE
        medicine_code = inputCode;
    COMMIT;
END;
/


-- 의료 행위 기초 정보
CREATE TABLE treatment_info
(
treatment_code    INTEGER NOT NULL,
treatment_name    VARCHAR2(60) NOT NULL,
unit_treatment_cost    INTEGER NOT NULL,
CONSTRAINT treatment_info_PK PRIMARY KEY ( treatment_code )
);

CREATE OR REPLACE PROCEDURE UPSERT_TREATMENT_INFO
(
    inputCode treatment_info.treatment_code%TYPE,
    inputName treatment_info.treatment_name%TYPE,
    inputCost treatment_info.unit_treatment_cost%TYPE
)
AS
BEGIN
INSERT INTO
    treatment_info (treatment_code, treatment_name, unit_treatment_cost)
VALUES
    (inputCode, inputName, inputCost);
COMMIT;
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
    UPDATE
        treatment_info
    SET
        treatment_name = inputName,
        unit_treatment_cost = inputCost
    WHERE
        treatment_code = inputCode;
    COMMIT;
END;
/


-- 진료 기록
CREATE TABLE diagnosis_record
(
registration_id    INTEGER NOT NULL,
diagnosis_datetime    TIMESTAMP NOT NULL,
kcd_code    VARCHAR2(20) NOT NULL,
clinic_name    VARCHAR2(30) NOT NULL,
doctor_name    VARCHAR2(10) NOT NULL,
doctor_comment    VARCHAR2(256),
CONSTRAINT diagnosis_record_PK PRIMARY KEY ( registration_id ),
CONSTRAINT diagnosis_record_FK_DR FOREIGN KEY ( registration_id ) REFERENCES diagnosis_registration( registration_id ),
CONSTRAINT diagnosis_record_FK_DI FOREIGN KEY ( kcd_code ) REFERENCES disease_info( kcd_code )
);


-- 처방된 약품 목록
CREATE TABLE prescribed_medicines
(
registration_id    INTEGER NOT NULL,
medicine_code    INTEGER NOT NULL,
single_dose     INTEGER NOT NULL,
daily_dose   INTEGER NOT NULL,
total_amount    INTEGER NOT NULL,
CONSTRAINT prescribed_medicines_PK PRIMARY KEY ( registration_id, medicine_code ),
CONSTRAINT prescribed_medicines_FK_DR FOREIGN KEY ( registration_id ) REFERENCES diagnosis_record( registration_id ),
CONSTRAINT prescribed_medicines_FK_MI FOREIGN KEY ( medicine_code ) REFERENCES medicine_info( medicine_code ) 
);


-- 처방된 의료 행위 목록
CREATE TABLE prescribed_treatments
(
registration_id    INTEGER NOT NULL,
treatment_code    INTEGER NOT NULL,
total_count     INTEGER NOT NULL,
CONSTRAINT prescribed_treatments_PK PRIMARY KEY ( registration_id, treatment_code ),
CONSTRAINT prescribed_treatments_FK_DR FOREIGN KEY ( registration_id ) REFERENCES diagnosis_record( registration_id ),
CONSTRAINT prescribed_treatments_FK_TC FOREIGN KEY ( treatment_code ) REFERENCES treatment_info( treatment_code )
);


-- 수납 정보
CREATE TABLE payment_info
(
registration_id    INTEGER NOT NULL,
total_diagnosis_cost    INTEGER NOT NULL,
total_treatment_cost    INTEGER NOT NULL,
payment_done    INTEGER NOT NULL,
CONSTRAINT payment_info_PK PRIMARY KEY ( registration_id ),
CONSTRAINT payment_info_FK FOREIGN KEY ( registration_id ) REFERENCES diagnosis_record( registration_id )
);


---------- 테스트 데이터 ----------
INSERT INTO disease_info VALUES('J00', '급성 비인두염[감기]', 5000);
INSERT INTO disease_info VALUES('E66', '과잉칼로리에 의한 비만', 5000);
INSERT INTO disease_info VALUES('K51', '궤양성 대장염', 5000);
INSERT INTO disease_info VALUES('T88', '예방접종에 따른 감염', 3000);
INSERT INTO disease_info VALUES('L65', '기타 비흉터성 모발손실', 10000);
INSERT INTO disease_info VALUES('L67', '모발색의 변화', 5000);
INSERT INTO disease_info VALUES('A05', '콜레라', 15000);
INSERT INTO disease_info VALUES('A41', '기타 패혈증', 30000);
INSERT INTO disease_info VALUES('R63', '섭취에 관계된 증상 및 징후', 10000);
INSERT INTO disease_info VALUES('Y63', '잘못 주입된 수액', 10000);

INSERT INTO medicine_info VALUES(100, '엘도씽캡슐');
INSERT INTO medicine_info VALUES(200, '아라스틴정');
INSERT INTO medicine_info VALUES(300, '휴모사정');
INSERT INTO medicine_info VALUES(400, '코대원정');
INSERT INTO medicine_info VALUES(500, '닥스펜정');
INSERT INTO medicine_info VALUES(600, '키도라제정');
INSERT INTO medicine_info VALUES(700, '노바스크정');
INSERT INTO medicine_info VALUES(800, '타미플루');
INSERT INTO medicine_info VALUES(900, '세니탈정');
INSERT INTO medicine_info VALUES(1000, '타이레놀정');

INSERT INTO treatment_info VALUES(1, '비만 치료', 100000);
INSERT INTO treatment_info VALUES(2, '레이저 시술', 50000);
INSERT INTO treatment_info VALUES(3, '소견서 발급', 10000);
INSERT INTO treatment_info VALUES(4, '초음파 검사', 50000);
INSERT INTO treatment_info VALUES(5, '알러지 검사', 150000);
INSERT INTO treatment_info VALUES(6, '예방 접종', 50000);
INSERT INTO treatment_info VALUES(7, '모발 검사', 100000);
INSERT INTO treatment_info VALUES(8, '네비도 주사', 230000);
INSERT INTO treatment_info VALUES(9, '수액 아미노산', 200000);
INSERT INTO treatment_info VALUES(10, '엑스레이 촬영', 5000);

COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이준혁', '400114-2222222', '서울특별시 노원구', '02-659-3006', '010-4015-4251', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 1, TO_TIMESTAMP('2021-12-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1, TO_TIMESTAMP('2021-12-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (1, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정정우', '400821-2222222', '서울특별시 중랑구', '02-598-3243', '010-6677-5728', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2021-12-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (2, TO_TIMESTAMP('2021-12-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (2, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장현서', '560106-2222222', '서울특별시 성북구', '02-148-6895', '010-6575-7802', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2021-12-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (3, TO_TIMESTAMP('2021-12-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(3, 300, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(3, 7, 3);
INSERT INTO prescribed_treatments VALUES(3, 9, 3);
INSERT INTO payment_info VALUES (3, 30000, 750000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정서준', '930824-2222222', '서울특별시 중랑구', '02-417-3440', '010-3359-9449', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2021-12-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (4, TO_TIMESTAMP('2021-12-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(4, 2, 3);
INSERT INTO payment_info VALUES (4, 10000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조건우', '990403-2222222', '서울특별시 용산구', '02-257-1654', '010-8377-7557', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 5, TO_TIMESTAMP('2021-12-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (5, TO_TIMESTAMP('2021-12-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (5, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김수아', '901221-2222222', '서울특별시 영등포구', '02-331-8861', '010-8669-4199', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 6, TO_TIMESTAMP('2021-12-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (6, TO_TIMESTAMP('2021-12-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (6, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허시연', '950317-2222222', '서울특별시 광진구', '02-735-6784', '010-2383-7918', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 7, TO_TIMESTAMP('2021-12-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (7, TO_TIMESTAMP('2021-12-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (7, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허수호', '750917-2222222', '서울특별시 동대문구', '02-215-5931', '010-2636-5419', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 8, TO_TIMESTAMP('2021-12-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (8, TO_TIMESTAMP('2021-12-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(8, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(8, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (8, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박승민', '200318-3333333', '서울특별시 성북구', '02-187-7954', '010-5813-5262', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2021-12-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (9, TO_TIMESTAMP('2021-12-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(9, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(9, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (9, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박다은', '330314-2222222', '서울특별시 종로구', '02-837-3977', '010-2089-2806', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 10, TO_TIMESTAMP('2021-12-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (10, TO_TIMESTAMP('2021-12-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(10, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(10, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(10, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (10, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이다인', '011013-4444444', '서울특별시 구로구', '02-968-3524', '010-2651-3429', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 11, TO_TIMESTAMP('2021-12-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (11, TO_TIMESTAMP('2021-12-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(11, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(11, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (11, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시온', '011028-3333333', '서울특별시 서초구', '02-769-8193', '010-7224-5903', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 12, TO_TIMESTAMP('2021-12-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (12, TO_TIMESTAMP('2021-12-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(12, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(12, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(12, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (12, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허현준', '270215-1111111', '서울특별시 성북구', '02-690-1825', '010-3955-5843', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 13, TO_TIMESTAMP('2021-12-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (13, TO_TIMESTAMP('2021-12-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(13, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(13, 500, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(13, 9, 2);
INSERT INTO payment_info VALUES (13, 10000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시현', '960410-2222222', '서울특별시 광진구', '02-884-4865', '010-3865-8481', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 14, TO_TIMESTAMP('2021-12-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (14, TO_TIMESTAMP('2021-12-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(14, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(14, 4, 1);
INSERT INTO payment_info VALUES (14, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍하윤', '060719-3333333', '서울특별시 서초구', '02-507-9764', '010-9186-5128', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 15, TO_TIMESTAMP('2021-12-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (15, TO_TIMESTAMP('2021-12-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(15, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(15, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (15, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서아', '670803-2222222', '서울특별시 성동구', '02-115-8327', '010-3940-1148', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2021-12-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (16, TO_TIMESTAMP('2021-12-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(16, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(16, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (16, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장우진', '440519-1111111', '서울특별시 은평구', '02-955-3080', '010-4177-1982', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 17, TO_TIMESTAMP('2021-12-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (17, TO_TIMESTAMP('2021-12-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(17, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(17, 1, 3);
INSERT INTO prescribed_treatments VALUES(17, 5, 2);
INSERT INTO payment_info VALUES (17, 10000, 600000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조아윤', '771113-1111111', '서울특별시 구로구', '02-650-9284', '010-3434-6798', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 18, TO_TIMESTAMP('2021-12-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (18, TO_TIMESTAMP('2021-12-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (18, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서현', '240412-2222222', '서울특별시 동작구', '02-209-2504', '010-8775-5100', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 19, TO_TIMESTAMP('2021-12-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (19, TO_TIMESTAMP('2021-12-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(19, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(19, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (19, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박도현', '190116-4444444', '서울특별시 성북구', '02-391-8007', '010-2393-2088', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 20, TO_TIMESTAMP('2021-12-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (20, TO_TIMESTAMP('2021-12-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(20, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (20, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조다온', '900107-2222222', '서울특별시 종로구', '02-309-6830', '010-6239-7422', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 21, TO_TIMESTAMP('2021-12-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (21, TO_TIMESTAMP('2021-12-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(21, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (21, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강서현', '750319-1111111', '서울특별시 동작구', '02-738-9161', '010-9110-2867', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 22, TO_TIMESTAMP('2021-12-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (22, TO_TIMESTAMP('2021-12-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(22, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(22, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (22, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박지환', '130719-4444444', '서울특별시 서대문구', '02-902-7622', '010-7737-7536', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 23, TO_TIMESTAMP('2021-12-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (23, TO_TIMESTAMP('2021-12-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(23, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (23, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍지민', '530225-2222222', '서울특별시 금천구', '02-566-4238', '010-4660-8369', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 24, TO_TIMESTAMP('2021-12-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (24, TO_TIMESTAMP('2021-12-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(24, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(24, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(24, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(24, 9, 3);
INSERT INTO prescribed_treatments VALUES(24, 2, 2);
INSERT INTO payment_info VALUES (24, 15000, 400000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시온', '580101-1111111', '서울특별시 강서구', '02-507-7377', '010-1504-9563', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2021-12-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (25, TO_TIMESTAMP('2021-12-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(25, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(25, 10, 3);
INSERT INTO prescribed_treatments VALUES(25, 3, 1);
INSERT INTO payment_info VALUES (25, 15000, 700000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박지호', '311107-2222222', '서울특별시 송파구', '02-238-3323', '010-7797-5795', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 26, TO_TIMESTAMP('2021-12-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (26, TO_TIMESTAMP('2021-12-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(26, 7, 2);
INSERT INTO prescribed_treatments VALUES(26, 5, 1);
INSERT INTO payment_info VALUES (26, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서연', '370424-1111111', '서울특별시 노원구', '02-322-1224', '010-2478-3647', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2021-12-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (27, TO_TIMESTAMP('2021-12-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(27, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(27, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (27, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조주원', '220201-3333333', '서울특별시 강서구', '02-662-2498', '010-7837-4630', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 28, TO_TIMESTAMP('2021-12-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (28, TO_TIMESTAMP('2021-12-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(28, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(28, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(28, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (28, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예린', '591203-2222222', '서울특별시 도봉구', '02-436-9029', '010-6876-8641', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2021-12-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (29, TO_TIMESTAMP('2021-12-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(29, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(29, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (29, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김아윤', '550209-2222222', '서울특별시 용산구', '02-675-3334', '010-4901-7729', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 30, TO_TIMESTAMP('2021-12-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (30, TO_TIMESTAMP('2021-12-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(30, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (30, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박지아', '620123-1111111', '서울특별시 광진구', '02-190-1709', '010-8198-1950', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 31, TO_TIMESTAMP('2021-12-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (31, TO_TIMESTAMP('2021-12-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (31, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2021-12-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (32, TO_TIMESTAMP('2021-12-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (32, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2021-12-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (33, TO_TIMESTAMP('2021-12-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (33, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김민지', '990317-2222222', '서울특별시 구로구', '02-792-2426', '010-3036-2744', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2021-12-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (34, TO_TIMESTAMP('2021-12-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(34, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(34, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(34, 1000, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(34, 2, 2);
INSERT INTO payment_info VALUES (34, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 30, TO_TIMESTAMP('2021-12-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (35, TO_TIMESTAMP('2021-12-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(35, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(35, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(35, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (35, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조서영', '810217-2222222', '서울특별시 관악구', '02-485-7994', '010-7695-2017', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 33, TO_TIMESTAMP('2021-12-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (36, TO_TIMESTAMP('2021-12-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(36, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(36, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(36, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(36, 6, 2);
INSERT INTO prescribed_treatments VALUES(36, 1, 1);
INSERT INTO payment_info VALUES (36, 10000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 8, TO_TIMESTAMP('2021-12-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (37, TO_TIMESTAMP('2021-12-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(37, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(37, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(37, 7, 1);
INSERT INTO payment_info VALUES (37, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이선우', '090706-4444444', '서울특별시 동대문구', '02-284-8809', '010-6728-5532', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2021-12-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (38, TO_TIMESTAMP('2021-12-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(38, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(38, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(38, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(38, 10, 2);
INSERT INTO prescribed_treatments VALUES(38, 1, 3);
INSERT INTO payment_info VALUES (38, 10000, 760000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2021-12-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (39, TO_TIMESTAMP('2021-12-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(39, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (39, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최윤서', '440427-2222222', '서울특별시 구로구', '02-893-1616', '010-8578-7004', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 35, TO_TIMESTAMP('2021-12-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (40, TO_TIMESTAMP('2021-12-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(40, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(40, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (40, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 28, TO_TIMESTAMP('2021-12-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (41, TO_TIMESTAMP('2021-12-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(41, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(41, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(41, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (41, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허하윤', '231002-2222222', '서울특별시 광진구', '02-144-3833', '010-8346-2138', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 36, TO_TIMESTAMP('2021-12-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (42, TO_TIMESTAMP('2021-12-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(42, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(42, 8, 1);
INSERT INTO payment_info VALUES (42, 30000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 31, TO_TIMESTAMP('2021-12-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (43, TO_TIMESTAMP('2021-12-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(43, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (43, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2021-12-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (44, TO_TIMESTAMP('2021-12-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(44, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(44, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (44, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이예서', '610323-1111111', '서울특별시 강서구', '02-400-8900', '010-3894-6868', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2021-12-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (45, TO_TIMESTAMP('2021-12-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (45, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2021-12-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (46, TO_TIMESTAMP('2021-12-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(46, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(46, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (46, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 6, TO_TIMESTAMP('2021-12-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (47, TO_TIMESTAMP('2021-12-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(47, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(47, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (47, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임이준', '370506-1111111', '서울특별시 마포구', '02-832-5137', '010-7827-8442', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 38, TO_TIMESTAMP('2021-12-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (48, TO_TIMESTAMP('2021-12-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (48, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2021-12-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (49, TO_TIMESTAMP('2021-12-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(49, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (49, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박현서', '610427-2222222', '서울특별시 도봉구', '02-642-2859', '010-4358-8323', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 39, TO_TIMESTAMP('2021-12-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (50, TO_TIMESTAMP('2021-12-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (50, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 11, TO_TIMESTAMP('2021-12-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (51, TO_TIMESTAMP('2021-12-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(51, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(51, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(51, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(51, 10, 2);
INSERT INTO prescribed_treatments VALUES(51, 2, 1);
INSERT INTO payment_info VALUES (51, 30000, 510000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2021-12-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (52, TO_TIMESTAMP('2021-12-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(52, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(52, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(52, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (52, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조윤우', '520723-1111111', '서울특별시 강서구', '02-659-6844', '010-5111-1312', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 40, TO_TIMESTAMP('2021-12-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (53, TO_TIMESTAMP('2021-12-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(53, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(53, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(53, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (53, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 39, TO_TIMESTAMP('2021-12-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (54, TO_TIMESTAMP('2021-12-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(54, 6, 3);
INSERT INTO prescribed_treatments VALUES(54, 9, 2);
INSERT INTO payment_info VALUES (54, 3000, 350000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이다은', '250410-2222222', '서울특별시 광진구', '02-474-7900', '010-5808-6880', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 41, TO_TIMESTAMP('2021-12-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (55, TO_TIMESTAMP('2021-12-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (55, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 24, TO_TIMESTAMP('2021-12-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (56, TO_TIMESTAMP('2021-12-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(56, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (56, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2021-12-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (57, TO_TIMESTAMP('2021-12-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(57, 700, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(57, 10, 1);
INSERT INTO prescribed_treatments VALUES(57, 6, 3);
INSERT INTO payment_info VALUES (57, 10000, 380000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조은우', '411220-2222222', '서울특별시 동작구', '02-792-8483', '010-1095-6822', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 42, TO_TIMESTAMP('2021-12-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (58, TO_TIMESTAMP('2021-12-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(58, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(58, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (58, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 26, TO_TIMESTAMP('2021-12-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (59, TO_TIMESTAMP('2021-12-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(59, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(59, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(59, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(59, 6, 3);
INSERT INTO payment_info VALUES (59, 15000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 13, TO_TIMESTAMP('2021-12-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (60, TO_TIMESTAMP('2021-12-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(60, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (60, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이선우', '100802-3333333', '서울특별시 강남구', '02-877-3609', '010-9495-2748', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 43, TO_TIMESTAMP('2021-12-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (61, TO_TIMESTAMP('2021-12-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(61, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(61, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(61, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (61, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2021-12-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (62, TO_TIMESTAMP('2021-12-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(62, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(62, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (62, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이채은', '551121-1111111', '서울특별시 도봉구', '02-788-8141', '010-8961-8881', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 44, TO_TIMESTAMP('2021-12-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (63, TO_TIMESTAMP('2021-12-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(63, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (63, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 19, TO_TIMESTAMP('2021-12-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (64, TO_TIMESTAMP('2021-12-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(64, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(64, 6, 3);
INSERT INTO payment_info VALUES (64, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정준서', '540301-1111111', '서울특별시 관악구', '02-335-5706', '010-9305-8529', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 45, TO_TIMESTAMP('2021-12-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (65, TO_TIMESTAMP('2021-12-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(65, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(65, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(65, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (65, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강선우', '871228-2222222', '서울특별시 송파구', '02-557-4038', '010-7543-6493', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2021-12-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (66, TO_TIMESTAMP('2021-12-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(66, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(66, 500, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(66, 7, 1);
INSERT INTO payment_info VALUES (66, 15000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 39, TO_TIMESTAMP('2021-12-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (67, TO_TIMESTAMP('2021-12-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(67, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (67, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강시후', '060522-4444444', '서울특별시 광진구', '02-878-3526', '010-2746-9073', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 47, TO_TIMESTAMP('2021-12-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (68, TO_TIMESTAMP('2021-12-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(68, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(68, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(68, 400, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(68, 4, 3);
INSERT INTO payment_info VALUES (68, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 23, TO_TIMESTAMP('2021-12-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (69, TO_TIMESTAMP('2021-12-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(69, 6, 1);
INSERT INTO payment_info VALUES (69, 3000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 6, TO_TIMESTAMP('2021-12-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (70, TO_TIMESTAMP('2021-12-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(70, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(70, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(70, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(70, 8, 1);
INSERT INTO prescribed_treatments VALUES(70, 1, 1);
INSERT INTO payment_info VALUES (70, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2021-12-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (71, TO_TIMESTAMP('2021-12-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(71, 7, 2);
INSERT INTO prescribed_treatments VALUES(71, 2, 1);
INSERT INTO payment_info VALUES (71, 10000, 350000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2021-12-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (72, TO_TIMESTAMP('2021-12-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (72, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최예린', '631224-1111111', '서울특별시 중구', '02-819-9825', '010-7730-8091', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 48, TO_TIMESTAMP('2021-12-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (73, TO_TIMESTAMP('2021-12-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(73, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(73, 5, 3);
INSERT INTO payment_info VALUES (73, 10000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유준', '990612-2222222', '서울특별시 마포구', '02-363-4150', '010-1258-2328', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 49, TO_TIMESTAMP('2021-12-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (74, TO_TIMESTAMP('2021-12-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(74, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(74, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(74, 5, 3);
INSERT INTO prescribed_treatments VALUES(74, 8, 3);
INSERT INTO payment_info VALUES (74, 10000, 600000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2021-12-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (75, TO_TIMESTAMP('2021-12-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(75, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (75, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 45, TO_TIMESTAMP('2021-12-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (76, TO_TIMESTAMP('2021-12-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(76, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(76, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(76, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (76, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 40, TO_TIMESTAMP('2021-12-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (77, TO_TIMESTAMP('2021-12-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(77, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(77, 1, 3);
INSERT INTO prescribed_treatments VALUES(77, 3, 2);
INSERT INTO payment_info VALUES (77, 5000, 320000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2021-12-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (78, TO_TIMESTAMP('2021-12-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(78, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(78, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (78, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시은', '640503-2222222', '서울특별시 서대문구', '02-970-8416', '010-4565-6430', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 50, TO_TIMESTAMP('2021-12-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (79, TO_TIMESTAMP('2021-12-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(79, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (79, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2021-12-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (80, TO_TIMESTAMP('2021-12-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(80, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (80, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민서', '990921-2222222', '서울특별시 중구', '02-895-4014', '010-4164-2235', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 51, TO_TIMESTAMP('2021-12-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (81, TO_TIMESTAMP('2021-12-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(81, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(81, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (81, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 49, TO_TIMESTAMP('2021-12-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (82, TO_TIMESTAMP('2021-12-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(82, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (82, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지안', '441106-2222222', '서울특별시 관악구', '02-698-9345', '010-4873-1127', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 52, TO_TIMESTAMP('2021-12-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (83, TO_TIMESTAMP('2021-12-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(83, 100, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(83, 4, 1);
INSERT INTO prescribed_treatments VALUES(83, 6, 3);
INSERT INTO payment_info VALUES (83, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 8, TO_TIMESTAMP('2022-01-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (84, TO_TIMESTAMP('2022-01-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (84, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서윤', '840519-2222222', '서울특별시 노원구', '02-249-3027', '010-7870-1173', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 53, TO_TIMESTAMP('2022-01-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (85, TO_TIMESTAMP('2022-01-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(85, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(85, 3, 1);
INSERT INTO payment_info VALUES (85, 10000, 10000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2022-01-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (86, TO_TIMESTAMP('2022-01-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(86, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(86, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (86, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박현서', '211005-3333333', '서울특별시 마포구', '02-317-4814', '010-6113-3405', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 54, TO_TIMESTAMP('2022-01-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (87, TO_TIMESTAMP('2022-01-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (87, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강민준', '111009-4444444', '서울특별시 관악구', '02-751-4026', '010-7888-6725', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 55, TO_TIMESTAMP('2022-01-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (88, TO_TIMESTAMP('2022-01-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(88, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(88, 3, 3);
INSERT INTO payment_info VALUES (88, 5000, 30000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조지민', '431116-2222222', '서울특별시 마포구', '02-410-1570', '010-9153-8632', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 56, TO_TIMESTAMP('2022-01-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (89, TO_TIMESTAMP('2022-01-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(89, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (89, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2022-01-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (90, TO_TIMESTAMP('2022-01-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(90, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (90, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장현서', '380427-1111111', '서울특별시 금천구', '02-376-5765', '010-6653-3019', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 57, TO_TIMESTAMP('2022-01-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (91, TO_TIMESTAMP('2022-01-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(91, 400, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(91, 8, 3);
INSERT INTO prescribed_treatments VALUES(91, 9, 1);
INSERT INTO payment_info VALUES (91, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 35, TO_TIMESTAMP('2022-01-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (92, TO_TIMESTAMP('2022-01-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(92, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(92, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(92, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(92, 7, 1);
INSERT INTO payment_info VALUES (92, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임아린', '210911-2222222', '서울특별시 송파구', '02-755-9079', '010-3206-5414', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 58, TO_TIMESTAMP('2022-01-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (93, TO_TIMESTAMP('2022-01-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(93, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (93, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 41, TO_TIMESTAMP('2022-01-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (94, TO_TIMESTAMP('2022-01-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (94, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조도윤', '190814-4444444', '서울특별시 강동구', '02-254-4248', '010-9836-3699', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 59, TO_TIMESTAMP('2022-01-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (95, TO_TIMESTAMP('2022-01-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(95, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(95, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(95, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (95, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 48, TO_TIMESTAMP('2022-01-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (96, TO_TIMESTAMP('2022-01-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(96, 1, 3);
INSERT INTO payment_info VALUES (96, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2022-01-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (97, TO_TIMESTAMP('2022-01-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(97, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(97, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(97, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (97, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-01-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (98, TO_TIMESTAMP('2022-01-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(98, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(98, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(98, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (98, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조연서', '551022-2222222', '서울특별시 중랑구', '02-264-2739', '010-7174-6579', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 60, TO_TIMESTAMP('2022-01-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (99, TO_TIMESTAMP('2022-01-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (99, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허예린', '091024-3333333', '서울특별시 강서구', '02-838-5073', '010-8039-9895', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 61, TO_TIMESTAMP('2022-01-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (100, TO_TIMESTAMP('2022-01-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(100, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(100, 6, 1);
INSERT INTO payment_info VALUES (100, 3000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 31, TO_TIMESTAMP('2022-01-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (101, TO_TIMESTAMP('2022-01-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(101, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (101, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강은우', '680926-2222222', '서울특별시 강남구', '02-635-5219', '010-7925-1655', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 62, TO_TIMESTAMP('2022-01-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (102, TO_TIMESTAMP('2022-01-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(102, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(102, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(102, 200, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(102, 6, 1);
INSERT INTO payment_info VALUES (102, 5000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 43, TO_TIMESTAMP('2022-01-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (103, TO_TIMESTAMP('2022-01-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (103, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허예린', '070316-4444444', '서울특별시 서대문구', '02-806-4286', '010-7684-2260', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 63, TO_TIMESTAMP('2022-01-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (104, TO_TIMESTAMP('2022-01-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(104, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (104, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강유빈', '181213-4444444', '서울특별시 구로구', '02-521-7396', '010-5791-7281', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 64, TO_TIMESTAMP('2022-01-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (105, TO_TIMESTAMP('2022-01-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(105, 800, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(105, 8, 2);
INSERT INTO prescribed_treatments VALUES(105, 10, 3);
INSERT INTO payment_info VALUES (105, 5000, 790000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 12, TO_TIMESTAMP('2022-01-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (106, TO_TIMESTAMP('2022-01-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (106, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강예서', '920805-2222222', '서울특별시 은평구', '02-196-3825', '010-9548-1767', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 65, TO_TIMESTAMP('2022-01-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (107, TO_TIMESTAMP('2022-01-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(107, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(107, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (107, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 62, TO_TIMESTAMP('2022-01-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (108, TO_TIMESTAMP('2022-01-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(108, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (108, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍수현', '050105-3333333', '서울특별시 동작구', '02-309-4890', '010-4066-7444', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 66, TO_TIMESTAMP('2022-01-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (109, TO_TIMESTAMP('2022-01-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(109, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (109, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유나', '770213-2222222', '서울특별시 중구', '02-888-8924', '010-5274-5577', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 67, TO_TIMESTAMP('2022-01-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (110, TO_TIMESTAMP('2022-01-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(110, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(110, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (110, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2022-01-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (111, TO_TIMESTAMP('2022-01-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(111, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(111, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(111, 700, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(111, 3, 2);
INSERT INTO payment_info VALUES (111, 5000, 20000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박윤우', '120111-4444444', '서울특별시 양천구', '02-205-7088', '010-2923-6512', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 68, TO_TIMESTAMP('2022-01-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (112, TO_TIMESTAMP('2022-01-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(112, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(112, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(112, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (112, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 21, TO_TIMESTAMP('2022-01-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (113, TO_TIMESTAMP('2022-01-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(113, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (113, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강수연', '900725-2222222', '서울특별시 서대문구', '02-217-6902', '010-4946-1040', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-01-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (114, TO_TIMESTAMP('2022-01-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (114, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍하준', '870622-1111111', '서울특별시 종로구', '02-883-8225', '010-3561-4993', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 70, TO_TIMESTAMP('2022-01-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (115, TO_TIMESTAMP('2022-01-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(115, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (115, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2022-01-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (116, TO_TIMESTAMP('2022-01-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(116, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(116, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(116, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (116, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정채원', '070221-3333333', '서울특별시 은평구', '02-610-5126', '010-9130-8142', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 71, TO_TIMESTAMP('2022-01-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (117, TO_TIMESTAMP('2022-01-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(117, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (117, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 53, TO_TIMESTAMP('2022-01-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (118, TO_TIMESTAMP('2022-01-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(118, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(118, 600, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(118, 7, 1);
INSERT INTO prescribed_treatments VALUES(118, 10, 1);
INSERT INTO payment_info VALUES (118, 5000, 380000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시우', '141020-4444444', '서울특별시 중랑구', '02-829-9006', '010-8714-7342', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 72, TO_TIMESTAMP('2022-01-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (119, TO_TIMESTAMP('2022-01-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(119, 800, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(119, 10, 3);
INSERT INTO prescribed_treatments VALUES(119, 2, 2);
INSERT INTO payment_info VALUES (119, 15000, 790000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-01-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (120, TO_TIMESTAMP('2022-01-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(120, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(120, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(120, 1, 3);
INSERT INTO payment_info VALUES (120, 15000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 50, TO_TIMESTAMP('2022-01-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (121, TO_TIMESTAMP('2022-01-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(121, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (121, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 62, TO_TIMESTAMP('2022-01-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (122, TO_TIMESTAMP('2022-01-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(122, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (122, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강서현', '351225-2222222', '서울특별시 동작구', '02-863-1645', '010-6043-6924', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 73, TO_TIMESTAMP('2022-01-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (123, TO_TIMESTAMP('2022-01-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(123, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(123, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(123, 3, 1);
INSERT INTO prescribed_treatments VALUES(123, 10, 2);
INSERT INTO payment_info VALUES (123, 10000, 470000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 44, TO_TIMESTAMP('2022-01-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (124, TO_TIMESTAMP('2022-01-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(124, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(124, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(124, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(124, 2, 3);
INSERT INTO prescribed_treatments VALUES(124, 10, 2);
INSERT INTO payment_info VALUES (124, 10000, 610000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민준', '460501-2222222', '서울특별시 영등포구', '02-336-4657', '010-9348-7003', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 74, TO_TIMESTAMP('2022-01-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (125, TO_TIMESTAMP('2022-01-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (125, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 67, TO_TIMESTAMP('2022-01-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (126, TO_TIMESTAMP('2022-01-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(126, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(126, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(126, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (126, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유주', '210508-1111111', '서울특별시 성동구', '02-525-4677', '010-3780-8262', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 75, TO_TIMESTAMP('2022-01-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (127, TO_TIMESTAMP('2022-01-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(127, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (127, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장예은', '190216-4444444', '서울특별시 영등포구', '02-619-7455', '010-3203-2933', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 76, TO_TIMESTAMP('2022-01-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (128, TO_TIMESTAMP('2022-01-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(128, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(128, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (128, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍하린', '480519-1111111', '서울특별시 노원구', '02-566-3364', '010-8465-6647', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 77, TO_TIMESTAMP('2022-01-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (129, TO_TIMESTAMP('2022-01-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(129, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(129, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(129, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (129, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 56, TO_TIMESTAMP('2022-01-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (130, TO_TIMESTAMP('2022-01-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(130, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(130, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (130, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍채윤', '541009-1111111', '서울특별시 도봉구', '02-123-8887', '010-2622-9966', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 78, TO_TIMESTAMP('2022-01-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (131, TO_TIMESTAMP('2022-01-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(131, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(131, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(131, 600, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(131, 3, 3);
INSERT INTO prescribed_treatments VALUES(131, 5, 2);
INSERT INTO payment_info VALUES (131, 10000, 330000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 58, TO_TIMESTAMP('2022-01-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (132, TO_TIMESTAMP('2022-01-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(132, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(132, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(132, 700, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(132, 2, 1);
INSERT INTO payment_info VALUES (132, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정수현', '220404-1111111', '서울특별시 강동구', '02-761-6547', '010-7767-5802', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 79, TO_TIMESTAMP('2022-01-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (133, TO_TIMESTAMP('2022-01-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(133, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(133, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (133, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 71, TO_TIMESTAMP('2022-01-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (134, TO_TIMESTAMP('2022-01-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(134, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(134, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (134, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장윤아', '380708-1111111', '서울특별시 강남구', '02-218-3164', '010-1280-9187', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 80, TO_TIMESTAMP('2022-01-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (135, TO_TIMESTAMP('2022-01-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(135, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (135, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 63, TO_TIMESTAMP('2022-01-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (136, TO_TIMESTAMP('2022-01-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(136, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(136, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(136, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (136, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정예원', '691016-2222222', '서울특별시 성북구', '02-314-1132', '010-4394-2588', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 81, TO_TIMESTAMP('2022-01-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (137, TO_TIMESTAMP('2022-01-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(137, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(137, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(137, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (137, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2022-01-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (138, TO_TIMESTAMP('2022-01-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (138, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 47, TO_TIMESTAMP('2022-01-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (139, TO_TIMESTAMP('2022-01-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(139, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(139, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (139, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박예원', '610904-2222222', '서울특별시 광진구', '02-487-4543', '010-2387-1616', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 82, TO_TIMESTAMP('2022-01-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (140, TO_TIMESTAMP('2022-01-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(140, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (140, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최소율', '320910-1111111', '서울특별시 광진구', '02-603-6100', '010-2165-3658', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 83, TO_TIMESTAMP('2022-01-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (141, TO_TIMESTAMP('2022-01-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(141, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(141, 7, 3);
INSERT INTO payment_info VALUES (141, 10000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시윤', '771018-2222222', '서울특별시 마포구', '02-165-6126', '010-3649-4196', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 84, TO_TIMESTAMP('2022-01-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (142, TO_TIMESTAMP('2022-01-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(142, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (142, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 50, TO_TIMESTAMP('2022-01-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (143, TO_TIMESTAMP('2022-01-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(143, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(143, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(143, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (143, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍수민', '231124-1111111', '서울특별시 중랑구', '02-745-9916', '010-7767-2790', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 85, TO_TIMESTAMP('2022-01-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (144, TO_TIMESTAMP('2022-01-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(144, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (144, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 77, TO_TIMESTAMP('2022-01-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (145, TO_TIMESTAMP('2022-01-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (145, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2022-01-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (146, TO_TIMESTAMP('2022-01-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(146, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(146, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (146, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 36, TO_TIMESTAMP('2022-01-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (147, TO_TIMESTAMP('2022-01-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (147, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-01-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (148, TO_TIMESTAMP('2022-01-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(148, 100, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(148, 2, 1);
INSERT INTO prescribed_treatments VALUES(148, 9, 2);
INSERT INTO payment_info VALUES (148, 5000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정은우', '110426-3333333', '서울특별시 종로구', '02-923-1476', '010-6485-3090', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 86, TO_TIMESTAMP('2022-01-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (149, TO_TIMESTAMP('2022-01-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(149, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(149, 4, 2);
INSERT INTO prescribed_treatments VALUES(149, 6, 2);
INSERT INTO payment_info VALUES (149, 10000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2022-01-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (150, TO_TIMESTAMP('2022-01-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (150, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2022-01-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (151, TO_TIMESTAMP('2022-01-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (151, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장아인', '571206-1111111', '서울특별시 동작구', '02-935-4751', '010-4007-5866', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 87, TO_TIMESTAMP('2022-01-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (152, TO_TIMESTAMP('2022-01-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(152, 1, 2);
INSERT INTO prescribed_treatments VALUES(152, 7, 1);
INSERT INTO payment_info VALUES (152, 5000, 350000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 59, TO_TIMESTAMP('2022-01-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (153, TO_TIMESTAMP('2022-01-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(153, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(153, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(153, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (153, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조정우', '821205-2222222', '서울특별시 중랑구', '02-400-6901', '010-9253-5887', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 88, TO_TIMESTAMP('2022-01-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (154, TO_TIMESTAMP('2022-01-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(154, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (154, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 11, TO_TIMESTAMP('2022-01-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (155, TO_TIMESTAMP('2022-01-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(155, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(155, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (155, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2022-01-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (156, TO_TIMESTAMP('2022-01-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(156, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (156, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최민서', '630827-1111111', '서울특별시 종로구', '02-627-5480', '010-1564-3520', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 89, TO_TIMESTAMP('2022-01-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (157, TO_TIMESTAMP('2022-01-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(157, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(157, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(157, 700, 1, 2, 5);
INSERT INTO payment_info VALUES (157, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 47, TO_TIMESTAMP('2022-01-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (158, TO_TIMESTAMP('2022-01-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(158, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (158, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서우', '241205-1111111', '서울특별시 서초구', '02-455-8715', '010-8260-4028', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 90, TO_TIMESTAMP('2022-01-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (159, TO_TIMESTAMP('2022-01-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(159, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(159, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(159, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (159, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 67, TO_TIMESTAMP('2022-01-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (160, TO_TIMESTAMP('2022-01-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(160, 2, 3);
INSERT INTO prescribed_treatments VALUES(160, 7, 1);
INSERT INTO payment_info VALUES (160, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강지원', '910827-2222222', '서울특별시 서초구', '02-187-3936', '010-6071-4388', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 91, TO_TIMESTAMP('2022-01-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (161, TO_TIMESTAMP('2022-01-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(161, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(161, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (161, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 5, TO_TIMESTAMP('2022-01-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (162, TO_TIMESTAMP('2022-01-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (162, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2022-01-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (163, TO_TIMESTAMP('2022-01-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(163, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(163, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(163, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (163, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 33, TO_TIMESTAMP('2022-01-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (164, TO_TIMESTAMP('2022-01-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (164, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 58, TO_TIMESTAMP('2022-01-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (165, TO_TIMESTAMP('2022-01-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (165, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유빈', '360326-2222222', '서울특별시 노원구', '02-615-9410', '010-6708-2767', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 92, TO_TIMESTAMP('2022-01-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (166, TO_TIMESTAMP('2022-01-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(166, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(166, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (166, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유주', '650326-2222222', '서울특별시 광진구', '02-763-7355', '010-5221-1012', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 93, TO_TIMESTAMP('2022-01-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (167, TO_TIMESTAMP('2022-01-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(167, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (167, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍현우', '650526-2222222', '서울특별시 강남구', '02-836-1296', '010-4742-9084', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 94, TO_TIMESTAMP('2022-01-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (168, TO_TIMESTAMP('2022-01-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(168, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(168, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (168, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유빈', '821013-2222222', '서울특별시 구로구', '02-236-3552', '010-7463-9967', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 95, TO_TIMESTAMP('2022-01-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (169, TO_TIMESTAMP('2022-01-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(169, 1, 3);
INSERT INTO payment_info VALUES (169, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 20, TO_TIMESTAMP('2022-01-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (170, TO_TIMESTAMP('2022-01-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(170, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(170, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(170, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (170, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정우진', '230222-2222222', '서울특별시 용산구', '02-578-8955', '010-4142-3427', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-01-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (171, TO_TIMESTAMP('2022-01-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(171, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (171, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-01-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (172, TO_TIMESTAMP('2022-01-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(172, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(172, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (172, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서연', '890817-1111111', '서울특별시 중구', '02-402-7434', '010-1782-3147', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 97, TO_TIMESTAMP('2022-01-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (173, TO_TIMESTAMP('2022-01-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(173, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (173, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강다온', '630516-1111111', '서울특별시 강동구', '02-706-8357', '010-1765-7928', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 98, TO_TIMESTAMP('2022-02-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (174, TO_TIMESTAMP('2022-02-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(174, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(174, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (174, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 22, TO_TIMESTAMP('2022-02-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (175, TO_TIMESTAMP('2022-02-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(175, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (175, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허우진', '101203-3333333', '서울특별시 강북구', '02-569-8162', '010-2117-2548', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 99, TO_TIMESTAMP('2022-02-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (176, TO_TIMESTAMP('2022-02-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (176, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍선우', '231228-1111111', '서울특별시 서대문구', '02-287-9554', '010-3963-3879', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 100, TO_TIMESTAMP('2022-02-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (177, TO_TIMESTAMP('2022-02-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(177, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(177, 1000, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(177, 1, 3);
INSERT INTO payment_info VALUES (177, 30000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 30, TO_TIMESTAMP('2022-02-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (178, TO_TIMESTAMP('2022-02-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (178, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 7, TO_TIMESTAMP('2022-02-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (179, TO_TIMESTAMP('2022-02-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(179, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(179, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(179, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (179, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최윤우', '970218-2222222', '서울특별시 광진구', '02-471-4827', '010-6578-9664', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 101, TO_TIMESTAMP('2022-02-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (180, TO_TIMESTAMP('2022-02-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(180, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(180, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(180, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (180, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 22, TO_TIMESTAMP('2022-02-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (181, TO_TIMESTAMP('2022-02-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(181, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(181, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(181, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(181, 6, 1);
INSERT INTO payment_info VALUES (181, 5000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 81, TO_TIMESTAMP('2022-02-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (182, TO_TIMESTAMP('2022-02-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (182, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 71, TO_TIMESTAMP('2022-02-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (183, TO_TIMESTAMP('2022-02-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(183, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (183, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최민재', '040822-4444444', '서울특별시 도봉구', '02-892-7072', '010-9884-3974', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 102, TO_TIMESTAMP('2022-02-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (184, TO_TIMESTAMP('2022-02-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(184, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(184, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (184, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강연우', '080322-3333333', '서울특별시 동대문구', '02-405-3482', '010-8508-7427', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 103, TO_TIMESTAMP('2022-02-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (185, TO_TIMESTAMP('2022-02-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(185, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (185, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허윤서', '190503-4444444', '서울특별시 노원구', '02-996-3518', '010-7072-8087', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 104, TO_TIMESTAMP('2022-02-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (186, TO_TIMESTAMP('2022-02-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(186, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(186, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (186, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-02-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (187, TO_TIMESTAMP('2022-02-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(187, 3, 2);
INSERT INTO prescribed_treatments VALUES(187, 10, 1);
INSERT INTO payment_info VALUES (187, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 40, TO_TIMESTAMP('2022-02-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (188, TO_TIMESTAMP('2022-02-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(188, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(188, 10, 1);
INSERT INTO payment_info VALUES (188, 10000, 230000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이소율', '381121-1111111', '서울특별시 노원구', '02-754-8805', '010-1608-4890', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 105, TO_TIMESTAMP('2022-02-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (189, TO_TIMESTAMP('2022-02-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(189, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(189, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(189, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (189, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허유빈', '440203-2222222', '서울특별시 영등포구', '02-675-3473', '010-9985-2612', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 106, TO_TIMESTAMP('2022-02-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (190, TO_TIMESTAMP('2022-02-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(190, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(190, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(190, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (190, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 93, TO_TIMESTAMP('2022-02-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (191, TO_TIMESTAMP('2022-02-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(191, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(191, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (191, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 61, TO_TIMESTAMP('2022-02-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (192, TO_TIMESTAMP('2022-02-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(192, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(192, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(192, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (192, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임채은', '320218-2222222', '서울특별시 노원구', '02-115-2035', '010-8688-8682', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 107, TO_TIMESTAMP('2022-02-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (193, TO_TIMESTAMP('2022-02-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(193, 7, 1);
INSERT INTO prescribed_treatments VALUES(193, 9, 2);
INSERT INTO payment_info VALUES (193, 3000, 350000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 54, TO_TIMESTAMP('2022-02-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (194, TO_TIMESTAMP('2022-02-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(194, 3, 2);
INSERT INTO payment_info VALUES (194, 10000, 20000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김준혁', '250325-1111111', '서울특별시 광진구', '02-968-1673', '010-6265-1748', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 108, TO_TIMESTAMP('2022-02-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (195, TO_TIMESTAMP('2022-02-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(195, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (195, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 58, TO_TIMESTAMP('2022-02-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (196, TO_TIMESTAMP('2022-02-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(196, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(196, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(196, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (196, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박연서', '230724-2222222', '서울특별시 동작구', '02-554-6636', '010-1308-9005', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 109, TO_TIMESTAMP('2022-02-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (197, TO_TIMESTAMP('2022-02-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(197, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (197, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 65, TO_TIMESTAMP('2022-02-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (198, TO_TIMESTAMP('2022-02-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(198, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(198, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(198, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (198, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조아린', '000918-3333333', '서울특별시 성북구', '02-613-9294', '010-5979-1765', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 110, TO_TIMESTAMP('2022-02-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (199, TO_TIMESTAMP('2022-02-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(199, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(199, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(199, 7, 1);
INSERT INTO prescribed_treatments VALUES(199, 3, 1);
INSERT INTO payment_info VALUES (199, 10000, 160000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 44, TO_TIMESTAMP('2022-02-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (200, TO_TIMESTAMP('2022-02-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(200, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(200, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(200, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (200, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이소율', '330310-2222222', '서울특별시 동대문구', '02-966-8234', '010-8853-5401', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 111, TO_TIMESTAMP('2022-02-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (201, TO_TIMESTAMP('2022-02-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(201, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(201, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(201, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (201, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 21, TO_TIMESTAMP('2022-02-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (202, TO_TIMESTAMP('2022-02-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(202, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(202, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (202, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지호', '631211-1111111', '서울특별시 서대문구', '02-184-1718', '010-8555-5941', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 112, TO_TIMESTAMP('2022-02-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (203, TO_TIMESTAMP('2022-02-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(203, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(203, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(203, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (203, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김하진', '910609-2222222', '서울특별시 용산구', '02-228-8403', '010-7775-3705', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-02-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (204, TO_TIMESTAMP('2022-02-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(204, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(204, 5, 3);
INSERT INTO prescribed_treatments VALUES(204, 4, 2);
INSERT INTO payment_info VALUES (204, 5000, 550000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 39, TO_TIMESTAMP('2022-02-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (205, TO_TIMESTAMP('2022-02-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(205, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(205, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (205, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시은', '740605-2222222', '서울특별시 강동구', '02-841-7347', '010-9184-5055', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 114, TO_TIMESTAMP('2022-02-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (206, TO_TIMESTAMP('2022-02-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(206, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(206, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (206, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 89, TO_TIMESTAMP('2022-02-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (207, TO_TIMESTAMP('2022-02-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (207, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서진', '631108-2222222', '서울특별시 도봉구', '02-332-6201', '010-5300-6065', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 115, TO_TIMESTAMP('2022-02-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (208, TO_TIMESTAMP('2022-02-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(208, 4, 3);
INSERT INTO prescribed_treatments VALUES(208, 7, 3);
INSERT INTO payment_info VALUES (208, 15000, 600000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2022-02-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (209, TO_TIMESTAMP('2022-02-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(209, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (209, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2022-02-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (210, TO_TIMESTAMP('2022-02-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(210, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(210, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(210, 6, 3);
INSERT INTO payment_info VALUES (210, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허시은', '980212-2222222', '서울특별시 서초구', '02-535-4167', '010-6006-2421', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 116, TO_TIMESTAMP('2022-02-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (211, TO_TIMESTAMP('2022-02-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(211, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(211, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(211, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (211, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-02-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (212, TO_TIMESTAMP('2022-02-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(212, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (212, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예은', '100814-4444444', '서울특별시 중구', '02-448-3617', '010-3295-7410', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 117, TO_TIMESTAMP('2022-02-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (213, TO_TIMESTAMP('2022-02-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(213, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (213, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예은', '120706-3333333', '서울특별시 영등포구', '02-799-2468', '010-4019-3187', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 118, TO_TIMESTAMP('2022-02-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (214, TO_TIMESTAMP('2022-02-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (214, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍진우', '211008-1111111', '서울특별시 강동구', '02-695-7455', '010-7129-7755', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 119, TO_TIMESTAMP('2022-02-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (215, TO_TIMESTAMP('2022-02-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(215, 100, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(215, 9, 2);
INSERT INTO payment_info VALUES (215, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강시윤', '330504-2222222', '서울특별시 동대문구', '02-774-1805', '010-7751-1215', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 120, TO_TIMESTAMP('2022-02-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (216, TO_TIMESTAMP('2022-02-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(216, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(216, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (216, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 45, TO_TIMESTAMP('2022-02-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (217, TO_TIMESTAMP('2022-02-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(217, 8, 3);
INSERT INTO prescribed_treatments VALUES(217, 4, 2);
INSERT INTO payment_info VALUES (217, 15000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 87, TO_TIMESTAMP('2022-02-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (218, TO_TIMESTAMP('2022-02-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(218, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(218, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(218, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (218, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허준영', '410307-2222222', '서울특별시 금천구', '02-695-6713', '010-9593-7745', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 121, TO_TIMESTAMP('2022-02-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (219, TO_TIMESTAMP('2022-02-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(219, 400, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(219, 5, 3);
INSERT INTO payment_info VALUES (219, 10000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정채윤', '891118-1111111', '서울특별시 강동구', '02-868-5112', '010-9276-4621', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 122, TO_TIMESTAMP('2022-02-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (220, TO_TIMESTAMP('2022-02-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(220, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (220, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지안', '991112-2222222', '서울특별시 양천구', '02-329-5207', '010-9769-5497', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 123, TO_TIMESTAMP('2022-02-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (221, TO_TIMESTAMP('2022-02-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (221, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지유', '670408-2222222', '서울특별시 은평구', '02-757-3031', '010-2258-9936', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 124, TO_TIMESTAMP('2022-02-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (222, TO_TIMESTAMP('2022-02-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(222, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (222, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지윤', '830626-1111111', '서울특별시 구로구', '02-409-6915', '010-3547-2545', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 125, TO_TIMESTAMP('2022-02-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (223, TO_TIMESTAMP('2022-02-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(223, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (223, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2022-02-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (224, TO_TIMESTAMP('2022-02-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(224, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(224, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (224, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허아윤', '091013-3333333', '서울특별시 양천구', '02-987-3092', '010-1364-2202', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 126, TO_TIMESTAMP('2022-02-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (225, TO_TIMESTAMP('2022-02-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(225, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(225, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (225, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유준', '101105-3333333', '서울특별시 영등포구', '02-565-9680', '010-2884-8907', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 127, TO_TIMESTAMP('2022-02-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (226, TO_TIMESTAMP('2022-02-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(226, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(226, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (226, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유준', '610220-2222222', '서울특별시 종로구', '02-667-4244', '010-4004-9214', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 128, TO_TIMESTAMP('2022-02-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (227, TO_TIMESTAMP('2022-02-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(227, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (227, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 53, TO_TIMESTAMP('2022-02-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (228, TO_TIMESTAMP('2022-02-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(228, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(228, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(228, 700, 1, 2, 5);
INSERT INTO payment_info VALUES (228, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시윤', '610726-1111111', '서울특별시 영등포구', '02-745-5714', '010-3825-4021', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 129, TO_TIMESTAMP('2022-02-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (229, TO_TIMESTAMP('2022-02-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(229, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (229, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 80, TO_TIMESTAMP('2022-02-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (230, TO_TIMESTAMP('2022-02-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(230, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(230, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(230, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(230, 8, 2);
INSERT INTO prescribed_treatments VALUES(230, 3, 2);
INSERT INTO payment_info VALUES (230, 3000, 120000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-02-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (231, TO_TIMESTAMP('2022-02-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(231, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(231, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (231, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2022-02-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (232, TO_TIMESTAMP('2022-02-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(232, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(232, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(232, 100, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(232, 10, 3);
INSERT INTO prescribed_treatments VALUES(232, 3, 1);
INSERT INTO payment_info VALUES (232, 10000, 700000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 8, TO_TIMESTAMP('2022-02-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (233, TO_TIMESTAMP('2022-02-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(233, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(233, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(233, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (233, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시현', '660810-1111111', '서울특별시 강서구', '02-396-5562', '010-2522-9535', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 130, TO_TIMESTAMP('2022-02-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (234, TO_TIMESTAMP('2022-02-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (234, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 10, TO_TIMESTAMP('2022-02-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (235, TO_TIMESTAMP('2022-02-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(235, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(235, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(235, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (235, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강채원', '930515-1111111', '서울특별시 은평구', '02-645-2561', '010-1997-4721', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 131, TO_TIMESTAMP('2022-02-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (236, TO_TIMESTAMP('2022-02-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(236, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(236, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (236, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 118, TO_TIMESTAMP('2022-02-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (237, TO_TIMESTAMP('2022-02-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(237, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(237, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (237, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지훈', '850720-2222222', '서울특별시 마포구', '02-946-8546', '010-4733-7362', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 132, TO_TIMESTAMP('2022-02-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (238, TO_TIMESTAMP('2022-02-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (238, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 23, TO_TIMESTAMP('2022-02-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (239, TO_TIMESTAMP('2022-02-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(239, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(239, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (239, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박시후', '600117-2222222', '서울특별시 금천구', '02-635-4594', '010-1672-9049', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 133, TO_TIMESTAMP('2022-02-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (240, TO_TIMESTAMP('2022-02-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(240, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(240, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (240, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 51, TO_TIMESTAMP('2022-02-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (241, TO_TIMESTAMP('2022-02-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(241, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(241, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(241, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (241, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임현우', '170501-3333333', '서울특별시 양천구', '02-377-3328', '010-9029-9087', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 134, TO_TIMESTAMP('2022-02-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (242, TO_TIMESTAMP('2022-02-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(242, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (242, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최하준', '800722-1111111', '서울특별시 마포구', '02-218-6518', '010-9642-8207', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 135, TO_TIMESTAMP('2022-02-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (243, TO_TIMESTAMP('2022-02-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(243, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(243, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(243, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(243, 10, 3);
INSERT INTO prescribed_treatments VALUES(243, 4, 2);
INSERT INTO payment_info VALUES (243, 15000, 790000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍윤우', '700711-1111111', '서울특별시 서대문구', '02-563-2963', '010-8949-7980', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 136, TO_TIMESTAMP('2022-02-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (244, TO_TIMESTAMP('2022-02-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(244, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (244, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지후', '020415-4444444', '서울특별시 강동구', '02-109-5182', '010-7466-6010', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 137, TO_TIMESTAMP('2022-02-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (245, TO_TIMESTAMP('2022-02-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(245, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(245, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (245, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 50, TO_TIMESTAMP('2022-02-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (246, TO_TIMESTAMP('2022-02-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(246, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(246, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(246, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (246, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시현', '521221-2222222', '서울특별시 송파구', '02-785-9331', '010-8086-4130', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 138, TO_TIMESTAMP('2022-02-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (247, TO_TIMESTAMP('2022-02-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (247, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유나', '370919-1111111', '서울특별시 서초구', '02-520-7333', '010-5036-9007', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 139, TO_TIMESTAMP('2022-02-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (248, TO_TIMESTAMP('2022-02-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(248, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(248, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (248, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-02-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (249, TO_TIMESTAMP('2022-02-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(249, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(249, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (249, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 20, TO_TIMESTAMP('2022-02-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (250, TO_TIMESTAMP('2022-02-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(250, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(250, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(250, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (250, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유주', '550217-2222222', '서울특별시 양천구', '02-359-6781', '010-1094-8282', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 140, TO_TIMESTAMP('2022-02-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (251, TO_TIMESTAMP('2022-02-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(251, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(251, 8, 3);
INSERT INTO payment_info VALUES (251, 3000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 101, TO_TIMESTAMP('2022-02-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (252, TO_TIMESTAMP('2022-02-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(252, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(252, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(252, 100, 1, 3, 5);
INSERT INTO payment_info VALUES (252, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 77, TO_TIMESTAMP('2022-02-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (253, TO_TIMESTAMP('2022-02-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(253, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(253, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(253, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (253, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍예서', '790122-1111111', '서울특별시 구로구', '02-186-7657', '010-8266-9503', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 141, TO_TIMESTAMP('2022-02-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (254, TO_TIMESTAMP('2022-02-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(254, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(254, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (254, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이준서', '330723-2222222', '서울특별시 서초구', '02-579-6095', '010-8690-4893', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 142, TO_TIMESTAMP('2022-03-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (255, TO_TIMESTAMP('2022-03-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(255, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (255, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유빈', '480318-1111111', '서울특별시 종로구', '02-323-3956', '010-7998-8907', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 143, TO_TIMESTAMP('2022-03-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (256, TO_TIMESTAMP('2022-03-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(256, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (256, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 76, TO_TIMESTAMP('2022-03-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (257, TO_TIMESTAMP('2022-03-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(257, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(257, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (257, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유주', '270607-1111111', '서울특별시 관악구', '02-866-8052', '010-9012-6500', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 144, TO_TIMESTAMP('2022-03-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (258, TO_TIMESTAMP('2022-03-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(258, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (258, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 61, TO_TIMESTAMP('2022-03-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (259, TO_TIMESTAMP('2022-03-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(259, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(259, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(259, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(259, 1, 1);
INSERT INTO prescribed_treatments VALUES(259, 2, 1);
INSERT INTO payment_info VALUES (259, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서아', '280226-2222222', '서울특별시 송파구', '02-873-8529', '010-9307-4587', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 145, TO_TIMESTAMP('2022-03-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (260, TO_TIMESTAMP('2022-03-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(260, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(260, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (260, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-03-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (261, TO_TIMESTAMP('2022-03-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(261, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(261, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (261, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-03-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (262, TO_TIMESTAMP('2022-03-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (262, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍민준', '330913-2222222', '서울특별시 강서구', '02-311-7692', '010-5755-3674', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 146, TO_TIMESTAMP('2022-03-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (263, TO_TIMESTAMP('2022-03-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(263, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (263, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 134, TO_TIMESTAMP('2022-03-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (264, TO_TIMESTAMP('2022-03-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(264, 7, 2);
INSERT INTO prescribed_treatments VALUES(264, 2, 3);
INSERT INTO payment_info VALUES (264, 15000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민재', '160715-4444444', '서울특별시 동작구', '02-859-6870', '010-6904-2711', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 147, TO_TIMESTAMP('2022-03-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (265, TO_TIMESTAMP('2022-03-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (265, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지윤', '610826-2222222', '서울특별시 마포구', '02-484-7547', '010-3507-7232', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 148, TO_TIMESTAMP('2022-03-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (266, TO_TIMESTAMP('2022-03-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(266, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(266, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (266, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 66, TO_TIMESTAMP('2022-03-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (267, TO_TIMESTAMP('2022-03-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(267, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(267, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (267, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박유나', '761120-2222222', '서울특별시 중구', '02-775-7985', '010-2922-1619', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 149, TO_TIMESTAMP('2022-03-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (268, TO_TIMESTAMP('2022-03-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (268, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정시연', '890103-1111111', '서울특별시 양천구', '02-896-2206', '010-6969-5538', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 150, TO_TIMESTAMP('2022-03-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (269, TO_TIMESTAMP('2022-03-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (269, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 100, TO_TIMESTAMP('2022-03-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (270, TO_TIMESTAMP('2022-03-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (270, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 51, TO_TIMESTAMP('2022-03-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (271, TO_TIMESTAMP('2022-03-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(271, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(271, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (271, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 110, TO_TIMESTAMP('2022-03-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (272, TO_TIMESTAMP('2022-03-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(272, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (272, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 133, TO_TIMESTAMP('2022-03-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (273, TO_TIMESTAMP('2022-03-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(273, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(273, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(273, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(273, 7, 2);
INSERT INTO prescribed_treatments VALUES(273, 4, 3);
INSERT INTO payment_info VALUES (273, 15000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 128, TO_TIMESTAMP('2022-03-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (274, TO_TIMESTAMP('2022-03-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(274, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (274, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 127, TO_TIMESTAMP('2022-03-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (275, TO_TIMESTAMP('2022-03-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(275, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(275, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (275, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시현', '860104-2222222', '서울특별시 강남구', '02-207-8506', '010-9741-1007', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 151, TO_TIMESTAMP('2022-03-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (276, TO_TIMESTAMP('2022-03-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(276, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(276, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(276, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(276, 5, 1);
INSERT INTO payment_info VALUES (276, 30000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장지후', '590818-2222222', '서울특별시 중구', '02-575-3465', '010-7081-6626', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 152, TO_TIMESTAMP('2022-03-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (277, TO_TIMESTAMP('2022-03-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(277, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(277, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (277, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 131, TO_TIMESTAMP('2022-03-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (278, TO_TIMESTAMP('2022-03-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(278, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (278, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박수빈', '581124-1111111', '서울특별시 동대문구', '02-196-6351', '010-6065-6629', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 153, TO_TIMESTAMP('2022-03-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (279, TO_TIMESTAMP('2022-03-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (279, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 120, TO_TIMESTAMP('2022-03-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (280, TO_TIMESTAMP('2022-03-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(280, 700, 1, 2, 5);
INSERT INTO payment_info VALUES (280, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장이준', '470724-2222222', '서울특별시 양천구', '02-348-1677', '010-8960-5517', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 154, TO_TIMESTAMP('2022-03-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (281, TO_TIMESTAMP('2022-03-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(281, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(281, 7, 1);
INSERT INTO payment_info VALUES (281, 3000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2022-03-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (282, TO_TIMESTAMP('2022-03-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(282, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (282, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시연', '001108-3333333', '서울특별시 강남구', '02-251-7078', '010-8164-4904', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 155, TO_TIMESTAMP('2022-03-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (283, TO_TIMESTAMP('2022-03-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(283, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(283, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(283, 1, 1);
INSERT INTO prescribed_treatments VALUES(283, 10, 3);
INSERT INTO payment_info VALUES (283, 3000, 790000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허도윤', '960309-2222222', '서울특별시 구로구', '02-325-5010', '010-2029-9055', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 156, TO_TIMESTAMP('2022-03-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (284, TO_TIMESTAMP('2022-03-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(284, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (284, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 94, TO_TIMESTAMP('2022-03-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (285, TO_TIMESTAMP('2022-03-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(285, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (285, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 106, TO_TIMESTAMP('2022-03-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (286, TO_TIMESTAMP('2022-03-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(286, 800, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(286, 10, 3);
INSERT INTO prescribed_treatments VALUES(286, 6, 3);
INSERT INTO payment_info VALUES (286, 5000, 840000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박수호', '430920-1111111', '서울특별시 성동구', '02-590-5949', '010-3486-4271', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 157, TO_TIMESTAMP('2022-03-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (287, TO_TIMESTAMP('2022-03-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (287, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 79, TO_TIMESTAMP('2022-03-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (288, TO_TIMESTAMP('2022-03-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(288, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(288, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (288, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강우진', '281210-1111111', '서울특별시 강북구', '02-412-3056', '010-4111-5296', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 158, TO_TIMESTAMP('2022-03-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (289, TO_TIMESTAMP('2022-03-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(289, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(289, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (289, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2022-03-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (290, TO_TIMESTAMP('2022-03-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(290, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(290, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(290, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (290, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장윤아', '591117-1111111', '서울특별시 도봉구', '02-555-7820', '010-5804-6332', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 159, TO_TIMESTAMP('2022-03-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (291, TO_TIMESTAMP('2022-03-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (291, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 93, TO_TIMESTAMP('2022-03-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (292, TO_TIMESTAMP('2022-03-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(292, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(292, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(292, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (292, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이하은', '950810-1111111', '서울특별시 동대문구', '02-867-5127', '010-5531-1368', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 160, TO_TIMESTAMP('2022-03-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (293, TO_TIMESTAMP('2022-03-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(293, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(293, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(293, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (293, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 48, TO_TIMESTAMP('2022-03-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (294, TO_TIMESTAMP('2022-03-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(294, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(294, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(294, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (294, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박수호', '400424-2222222', '서울특별시 마포구', '02-594-6897', '010-6518-3481', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 161, TO_TIMESTAMP('2022-03-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (295, TO_TIMESTAMP('2022-03-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(295, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(295, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(295, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(295, 6, 2);
INSERT INTO prescribed_treatments VALUES(295, 1, 1);
INSERT INTO payment_info VALUES (295, 3000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조민재', '120208-4444444', '서울특별시 송파구', '02-727-5038', '010-2794-8123', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 162, TO_TIMESTAMP('2022-03-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (296, TO_TIMESTAMP('2022-03-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (296, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 104, TO_TIMESTAMP('2022-03-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (297, TO_TIMESTAMP('2022-03-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(297, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(297, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (297, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 151, TO_TIMESTAMP('2022-03-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (298, TO_TIMESTAMP('2022-03-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(298, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(298, 9, 2);
INSERT INTO prescribed_treatments VALUES(298, 7, 3);
INSERT INTO payment_info VALUES (298, 10000, 650000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김수빈', '431201-1111111', '서울특별시 노원구', '02-956-6190', '010-4652-7494', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 163, TO_TIMESTAMP('2022-03-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (299, TO_TIMESTAMP('2022-03-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(299, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(299, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(299, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (299, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 163, TO_TIMESTAMP('2022-03-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (300, TO_TIMESTAMP('2022-03-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (300, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 48, TO_TIMESTAMP('2022-03-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (301, TO_TIMESTAMP('2022-03-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(301, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(301, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(301, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (301, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김현서', '551105-2222222', '서울특별시 강동구', '02-202-9421', '010-3638-5851', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 164, TO_TIMESTAMP('2022-03-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (302, TO_TIMESTAMP('2022-03-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (302, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지민', '270501-1111111', '서울특별시 양천구', '02-743-9088', '010-6301-4315', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 165, TO_TIMESTAMP('2022-03-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (303, TO_TIMESTAMP('2022-03-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(303, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(303, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (303, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 93, TO_TIMESTAMP('2022-03-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (304, TO_TIMESTAMP('2022-03-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(304, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (304, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 36, TO_TIMESTAMP('2022-03-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (305, TO_TIMESTAMP('2022-03-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (305, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 91, TO_TIMESTAMP('2022-03-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (306, TO_TIMESTAMP('2022-03-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (306, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시아', '140509-4444444', '서울특별시 광진구', '02-684-2045', '010-1116-9412', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 166, TO_TIMESTAMP('2022-03-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (307, TO_TIMESTAMP('2022-03-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(307, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(307, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (307, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 156, TO_TIMESTAMP('2022-03-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (308, TO_TIMESTAMP('2022-03-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (308, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유빈', '841209-2222222', '서울특별시 영등포구', '02-455-9550', '010-4139-8527', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 167, TO_TIMESTAMP('2022-03-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (309, TO_TIMESTAMP('2022-03-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(309, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(309, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(309, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (309, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-03-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (310, TO_TIMESTAMP('2022-03-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(310, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(310, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(310, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (310, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서율', '460128-1111111', '서울특별시 동작구', '02-687-6969', '010-5211-9321', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 168, TO_TIMESTAMP('2022-03-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (311, TO_TIMESTAMP('2022-03-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(311, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(311, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(311, 500, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(311, 6, 2);
INSERT INTO payment_info VALUES (311, 15000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 28, TO_TIMESTAMP('2022-03-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (312, TO_TIMESTAMP('2022-03-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(312, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (312, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 90, TO_TIMESTAMP('2022-03-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (313, TO_TIMESTAMP('2022-03-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(313, 500, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(313, 6, 2);
INSERT INTO payment_info VALUES (313, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-03-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (314, TO_TIMESTAMP('2022-03-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(314, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(314, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(314, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (314, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이예나', '691119-2222222', '서울특별시 성북구', '02-459-7837', '010-5039-9476', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 169, TO_TIMESTAMP('2022-03-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (315, TO_TIMESTAMP('2022-03-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(315, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(315, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(315, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(315, 6, 1);
INSERT INTO payment_info VALUES (315, 15000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 81, TO_TIMESTAMP('2022-03-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (316, TO_TIMESTAMP('2022-03-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(316, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(316, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(316, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (316, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허이안', '070914-3333333', '서울특별시 성북구', '02-409-4717', '010-5020-7893', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 170, TO_TIMESTAMP('2022-03-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (317, TO_TIMESTAMP('2022-03-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(317, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(317, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (317, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 28, TO_TIMESTAMP('2022-03-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (318, TO_TIMESTAMP('2022-03-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(318, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(318, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (318, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최다온', '760717-2222222', '서울특별시 마포구', '02-652-8501', '010-8205-9085', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 171, TO_TIMESTAMP('2022-03-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (319, TO_TIMESTAMP('2022-03-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(319, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(319, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (319, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허윤아', '221223-3333333', '서울특별시 관악구', '02-993-5752', '010-2177-6460', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 172, TO_TIMESTAMP('2022-03-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (320, TO_TIMESTAMP('2022-03-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (320, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 75, TO_TIMESTAMP('2022-03-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (321, TO_TIMESTAMP('2022-03-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(321, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(321, 8, 1);
INSERT INTO payment_info VALUES (321, 10000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 148, TO_TIMESTAMP('2022-03-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (322, TO_TIMESTAMP('2022-03-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (322, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김현서', '780518-1111111', '서울특별시 금천구', '02-429-5442', '010-8704-5038', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 173, TO_TIMESTAMP('2022-03-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (323, TO_TIMESTAMP('2022-03-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(323, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(323, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(323, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (323, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서현', '410113-1111111', '서울특별시 강동구', '02-976-7894', '010-8586-2685', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 174, TO_TIMESTAMP('2022-03-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (324, TO_TIMESTAMP('2022-03-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(324, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(324, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (324, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 36, TO_TIMESTAMP('2022-03-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (325, TO_TIMESTAMP('2022-03-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(325, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(325, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(325, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(325, 9, 3);
INSERT INTO prescribed_treatments VALUES(325, 5, 2);
INSERT INTO payment_info VALUES (325, 10000, 600000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임이안', '861003-1111111', '서울특별시 강서구', '02-819-3299', '010-1831-4977', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 175, TO_TIMESTAMP('2022-03-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (326, TO_TIMESTAMP('2022-03-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(326, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (326, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 110, TO_TIMESTAMP('2022-03-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (327, TO_TIMESTAMP('2022-03-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(327, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(327, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(327, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (327, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지아', '280827-1111111', '서울특별시 마포구', '02-945-7965', '010-6731-1168', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 176, TO_TIMESTAMP('2022-03-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (328, TO_TIMESTAMP('2022-03-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(328, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(328, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(328, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (328, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장민서', '561016-1111111', '서울특별시 동대문구', '02-426-7876', '010-9624-7798', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 177, TO_TIMESTAMP('2022-03-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (329, TO_TIMESTAMP('2022-03-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(329, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(329, 8, 3);
INSERT INTO payment_info VALUES (329, 3000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 131, TO_TIMESTAMP('2022-03-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (330, TO_TIMESTAMP('2022-03-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(330, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (330, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 66, TO_TIMESTAMP('2022-03-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (331, TO_TIMESTAMP('2022-03-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (331, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조도현', '141106-3333333', '서울특별시 중구', '02-253-7956', '010-6691-2467', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 178, TO_TIMESTAMP('2022-03-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (332, TO_TIMESTAMP('2022-03-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(332, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (332, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 106, TO_TIMESTAMP('2022-03-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (333, TO_TIMESTAMP('2022-03-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(333, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(333, 9, 1);
INSERT INTO prescribed_treatments VALUES(333, 4, 3);
INSERT INTO payment_info VALUES (333, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 165, TO_TIMESTAMP('2022-03-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (334, TO_TIMESTAMP('2022-03-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(334, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(334, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(334, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (334, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 144, TO_TIMESTAMP('2022-03-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (335, TO_TIMESTAMP('2022-03-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(335, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(335, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(335, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (335, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임유진', '441228-2222222', '서울특별시 양천구', '02-837-8399', '010-4117-7670', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 179, TO_TIMESTAMP('2022-03-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (336, TO_TIMESTAMP('2022-03-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(336, 9, 3);
INSERT INTO prescribed_treatments VALUES(336, 7, 3);
INSERT INTO payment_info VALUES (336, 10000, 750000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허하준', '950820-1111111', '서울특별시 영등포구', '02-206-8591', '010-1857-4431', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 180, TO_TIMESTAMP('2022-03-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (337, TO_TIMESTAMP('2022-03-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(337, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (337, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 6, TO_TIMESTAMP('2022-03-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (338, TO_TIMESTAMP('2022-03-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(338, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(338, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(338, 100, 1, 3, 5);
INSERT INTO payment_info VALUES (338, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 156, TO_TIMESTAMP('2022-03-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (339, TO_TIMESTAMP('2022-03-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (339, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허주원', '950116-2222222', '서울특별시 서대문구', '02-548-3239', '010-3570-4276', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 181, TO_TIMESTAMP('2022-03-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (340, TO_TIMESTAMP('2022-03-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(340, 500, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(340, 1, 3);
INSERT INTO payment_info VALUES (340, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 117, TO_TIMESTAMP('2022-03-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (341, TO_TIMESTAMP('2022-03-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (341, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 105, TO_TIMESTAMP('2022-03-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (342, TO_TIMESTAMP('2022-03-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(342, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(342, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (342, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 49, TO_TIMESTAMP('2022-03-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (343, TO_TIMESTAMP('2022-03-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(343, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(343, 100, 1, 3, 5);
INSERT INTO payment_info VALUES (343, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이가은', '991122-2222222', '서울특별시 종로구', '02-669-8012', '010-2988-4891', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 182, TO_TIMESTAMP('2022-03-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (344, TO_TIMESTAMP('2022-03-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(344, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(344, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (344, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 126, TO_TIMESTAMP('2022-03-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (345, TO_TIMESTAMP('2022-03-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(345, 3, 2);
INSERT INTO payment_info VALUES (345, 10000, 20000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 108, TO_TIMESTAMP('2022-03-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (346, TO_TIMESTAMP('2022-03-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(346, 100, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(346, 6, 3);
INSERT INTO payment_info VALUES (346, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이윤우', '530503-2222222', '서울특별시 노원구', '02-408-5529', '010-5608-7006', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 183, TO_TIMESTAMP('2022-04-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (347, TO_TIMESTAMP('2022-04-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(347, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(347, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(347, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (347, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이은서', '010207-3333333', '서울특별시 금천구', '02-760-7137', '010-3370-5820', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 184, TO_TIMESTAMP('2022-04-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (348, TO_TIMESTAMP('2022-04-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(348, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(348, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(348, 2, 1);
INSERT INTO prescribed_treatments VALUES(348, 8, 3);
INSERT INTO payment_info VALUES (348, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 109, TO_TIMESTAMP('2022-04-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (349, TO_TIMESTAMP('2022-04-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(349, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(349, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(349, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (349, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 90, TO_TIMESTAMP('2022-04-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (350, TO_TIMESTAMP('2022-04-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(350, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(350, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(350, 100, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(350, 7, 3);
INSERT INTO prescribed_treatments VALUES(350, 1, 2);
INSERT INTO payment_info VALUES (350, 5000, 650000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허다은', '330321-1111111', '서울특별시 서대문구', '02-279-2266', '010-4775-1705', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 185, TO_TIMESTAMP('2022-04-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (351, TO_TIMESTAMP('2022-04-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(351, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(351, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (351, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 133, TO_TIMESTAMP('2022-04-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (352, TO_TIMESTAMP('2022-04-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (352, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 104, TO_TIMESTAMP('2022-04-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (353, TO_TIMESTAMP('2022-04-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(353, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(353, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(353, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(353, 8, 3);
INSERT INTO payment_info VALUES (353, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 98, TO_TIMESTAMP('2022-04-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (354, TO_TIMESTAMP('2022-04-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(354, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(354, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(354, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(354, 4, 3);
INSERT INTO prescribed_treatments VALUES(354, 9, 3);
INSERT INTO payment_info VALUES (354, 3000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 131, TO_TIMESTAMP('2022-04-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (355, TO_TIMESTAMP('2022-04-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (355, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강아린', '360626-1111111', '서울특별시 중랑구', '02-198-2381', '010-5781-7760', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 186, TO_TIMESTAMP('2022-04-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (356, TO_TIMESTAMP('2022-04-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(356, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(356, 4, 3);
INSERT INTO payment_info VALUES (356, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 101, TO_TIMESTAMP('2022-04-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (357, TO_TIMESTAMP('2022-04-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(357, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(357, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(357, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (357, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이도윤', '511203-1111111', '서울특별시 서대문구', '02-318-4321', '010-9054-9038', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 187, TO_TIMESTAMP('2022-04-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (358, TO_TIMESTAMP('2022-04-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(358, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(358, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(358, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (358, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2022-04-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (359, TO_TIMESTAMP('2022-04-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (359, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 85, TO_TIMESTAMP('2022-04-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (360, TO_TIMESTAMP('2022-04-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (360, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-04-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (361, TO_TIMESTAMP('2022-04-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(361, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(361, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(361, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(361, 10, 2);
INSERT INTO prescribed_treatments VALUES(361, 9, 1);
INSERT INTO payment_info VALUES (361, 15000, 560000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 78, TO_TIMESTAMP('2022-04-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (362, TO_TIMESTAMP('2022-04-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (362, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허하준', '941223-1111111', '서울특별시 광진구', '02-264-8077', '010-2920-3026', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 188, TO_TIMESTAMP('2022-04-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (363, TO_TIMESTAMP('2022-04-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(363, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (363, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2022-04-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (364, TO_TIMESTAMP('2022-04-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(364, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(364, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(364, 4, 1);
INSERT INTO payment_info VALUES (364, 10000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2022-04-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (365, TO_TIMESTAMP('2022-04-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(365, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(365, 6, 3);
INSERT INTO payment_info VALUES (365, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 72, TO_TIMESTAMP('2022-04-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (366, TO_TIMESTAMP('2022-04-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (366, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 126, TO_TIMESTAMP('2022-04-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (367, TO_TIMESTAMP('2022-04-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(367, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (367, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이지민', '981103-1111111', '서울특별시 강남구', '02-721-5943', '010-8560-6124', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 189, TO_TIMESTAMP('2022-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (368, TO_TIMESTAMP('2022-04-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (368, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김민준', '190202-3333333', '서울특별시 서초구', '02-168-2009', '010-2364-2424', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 190, TO_TIMESTAMP('2022-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (369, TO_TIMESTAMP('2022-04-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(369, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(369, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(369, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (369, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 114, TO_TIMESTAMP('2022-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (370, TO_TIMESTAMP('2022-04-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(370, 600, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(370, 9, 1);
INSERT INTO payment_info VALUES (370, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 81, TO_TIMESTAMP('2022-04-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (371, TO_TIMESTAMP('2022-04-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(371, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(371, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(371, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (371, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김승우', '721113-1111111', '서울특별시 성북구', '02-363-8953', '010-8764-2418', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 191, TO_TIMESTAMP('2022-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (372, TO_TIMESTAMP('2022-04-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(372, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(372, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(372, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(372, 3, 2);
INSERT INTO payment_info VALUES (372, 10000, 20000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (373, TO_TIMESTAMP('2022-04-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(373, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (373, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 20, TO_TIMESTAMP('2022-04-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (374, TO_TIMESTAMP('2022-04-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(374, 1, 3);
INSERT INTO prescribed_treatments VALUES(374, 9, 3);
INSERT INTO payment_info VALUES (374, 10000, 600000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서진', '001109-4444444', '서울특별시 은평구', '02-273-6244', '010-5730-9356', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 192, TO_TIMESTAMP('2022-04-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (375, TO_TIMESTAMP('2022-04-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(375, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(375, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (375, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 78, TO_TIMESTAMP('2022-04-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (376, TO_TIMESTAMP('2022-04-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(376, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(376, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(376, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (376, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 152, TO_TIMESTAMP('2022-04-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (377, TO_TIMESTAMP('2022-04-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(377, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (377, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정다인', '660220-2222222', '서울특별시 관악구', '02-596-3052', '010-4773-4848', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 193, TO_TIMESTAMP('2022-04-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (378, TO_TIMESTAMP('2022-04-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(378, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (378, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시은', '650612-1111111', '서울특별시 동작구', '02-475-8566', '010-8645-6041', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 194, TO_TIMESTAMP('2022-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (379, TO_TIMESTAMP('2022-04-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (379, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 89, TO_TIMESTAMP('2022-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (380, TO_TIMESTAMP('2022-04-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (380, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강윤아', '150306-3333333', '서울특별시 동작구', '02-832-7459', '010-8662-3374', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 195, TO_TIMESTAMP('2022-04-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (381, TO_TIMESTAMP('2022-04-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (381, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 112, TO_TIMESTAMP('2022-04-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (382, TO_TIMESTAMP('2022-04-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(382, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(382, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(382, 10, 2);
INSERT INTO prescribed_treatments VALUES(382, 6, 3);
INSERT INTO payment_info VALUES (382, 10000, 610000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 169, TO_TIMESTAMP('2022-04-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (383, TO_TIMESTAMP('2022-04-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(383, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(383, 4, 3);
INSERT INTO prescribed_treatments VALUES(383, 2, 1);
INSERT INTO payment_info VALUES (383, 15000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이예진', '510112-2222222', '서울특별시 노원구', '02-304-3962', '010-5035-5849', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 196, TO_TIMESTAMP('2022-04-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (384, TO_TIMESTAMP('2022-04-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(384, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (384, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 101, TO_TIMESTAMP('2022-04-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (385, TO_TIMESTAMP('2022-04-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(385, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(385, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (385, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 141, TO_TIMESTAMP('2022-04-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (386, TO_TIMESTAMP('2022-04-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(386, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(386, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (386, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2022-04-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (387, TO_TIMESTAMP('2022-04-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(387, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(387, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (387, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이하은', '440814-2222222', '서울특별시 동대문구', '02-759-1836', '010-7680-1576', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 197, TO_TIMESTAMP('2022-04-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (388, TO_TIMESTAMP('2022-04-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(388, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(388, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (388, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 61, TO_TIMESTAMP('2022-04-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (389, TO_TIMESTAMP('2022-04-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(389, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(389, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(389, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (389, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서현', '570903-1111111', '서울특별시 송파구', '02-245-2933', '010-8118-4713', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 198, TO_TIMESTAMP('2022-04-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (390, TO_TIMESTAMP('2022-04-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (390, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예원', '580224-2222222', '서울특별시 종로구', '02-478-6292', '010-8370-8414', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 199, TO_TIMESTAMP('2022-04-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (391, TO_TIMESTAMP('2022-04-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(391, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(391, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(391, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (391, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정시윤', '660318-2222222', '서울특별시 성북구', '02-979-9671', '010-1125-2142', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 200, TO_TIMESTAMP('2022-04-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (392, TO_TIMESTAMP('2022-04-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(392, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(392, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(392, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (392, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지유', '130527-4444444', '서울특별시 은평구', '02-125-1195', '010-4121-9518', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 201, TO_TIMESTAMP('2022-04-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (393, TO_TIMESTAMP('2022-04-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(393, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (393, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 14, TO_TIMESTAMP('2022-04-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (394, TO_TIMESTAMP('2022-04-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(394, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(394, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(394, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (394, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최가은', '710304-2222222', '서울특별시 서초구', '02-208-6820', '010-6806-1532', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 202, TO_TIMESTAMP('2022-04-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (395, TO_TIMESTAMP('2022-04-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(395, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(395, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(395, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (395, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서윤', '220914-4444444', '서울특별시 강동구', '02-606-6524', '010-8730-5108', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 203, TO_TIMESTAMP('2022-04-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (396, TO_TIMESTAMP('2022-04-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (396, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 14, TO_TIMESTAMP('2022-04-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (397, TO_TIMESTAMP('2022-04-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(397, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(397, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (397, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임은서', '380213-1111111', '서울특별시 강남구', '02-157-2147', '010-8279-9081', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 204, TO_TIMESTAMP('2022-04-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (398, TO_TIMESTAMP('2022-04-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(398, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(398, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(398, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (398, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 140, TO_TIMESTAMP('2022-04-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (399, TO_TIMESTAMP('2022-04-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(399, 600, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(399, 1, 3);
INSERT INTO prescribed_treatments VALUES(399, 10, 3);
INSERT INTO payment_info VALUES (399, 5000, 990000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-04-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (400, TO_TIMESTAMP('2022-04-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(400, 5, 1);
INSERT INTO payment_info VALUES (400, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유준', '260315-1111111', '서울특별시 중랑구', '02-536-7080', '010-2246-7739', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 205, TO_TIMESTAMP('2022-04-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (401, TO_TIMESTAMP('2022-04-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (401, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박승민', '120226-3333333', '서울특별시 관악구', '02-373-1783', '010-1485-8731', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 206, TO_TIMESTAMP('2022-04-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (402, TO_TIMESTAMP('2022-04-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(402, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (402, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 117, TO_TIMESTAMP('2022-04-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (403, TO_TIMESTAMP('2022-04-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(403, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(403, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(403, 2, 2);
INSERT INTO prescribed_treatments VALUES(403, 10, 2);
INSERT INTO payment_info VALUES (403, 30000, 560000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 180, TO_TIMESTAMP('2022-04-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (404, TO_TIMESTAMP('2022-04-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(404, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (404, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서영', '900713-2222222', '서울특별시 성북구', '02-313-2401', '010-5684-4672', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 207, TO_TIMESTAMP('2022-04-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (405, TO_TIMESTAMP('2022-04-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(405, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (405, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 21, TO_TIMESTAMP('2022-04-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (406, TO_TIMESTAMP('2022-04-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(406, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(406, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (406, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장예진', '410522-2222222', '서울특별시 동작구', '02-418-6933', '010-9626-9633', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 208, TO_TIMESTAMP('2022-04-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (407, TO_TIMESTAMP('2022-04-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(407, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(407, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(407, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (407, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 194, TO_TIMESTAMP('2022-04-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (408, TO_TIMESTAMP('2022-04-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(408, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(408, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(408, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (408, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정수민', '270111-1111111', '서울특별시 종로구', '02-745-7566', '010-5112-1193', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 209, TO_TIMESTAMP('2022-04-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (409, TO_TIMESTAMP('2022-04-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(409, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(409, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (409, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2022-04-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (410, TO_TIMESTAMP('2022-04-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(410, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (410, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 204, TO_TIMESTAMP('2022-04-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (411, TO_TIMESTAMP('2022-04-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(411, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(411, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (411, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍지유', '210825-3333333', '서울특별시 성동구', '02-480-4827', '010-8360-7723', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 210, TO_TIMESTAMP('2022-04-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (412, TO_TIMESTAMP('2022-04-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (412, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 84, TO_TIMESTAMP('2022-04-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (413, TO_TIMESTAMP('2022-04-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(413, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(413, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(413, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (413, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지민', '710303-1111111', '서울특별시 서대문구', '02-756-9776', '010-8197-4951', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 211, TO_TIMESTAMP('2022-04-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (414, TO_TIMESTAMP('2022-04-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(414, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(414, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (414, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최윤아', '411004-2222222', '서울특별시 중구', '02-825-9382', '010-4690-6400', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 212, TO_TIMESTAMP('2022-04-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (415, TO_TIMESTAMP('2022-04-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (415, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 3, TO_TIMESTAMP('2022-04-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (416, TO_TIMESTAMP('2022-04-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(416, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(416, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (416, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조수연', '300110-2222222', '서울특별시 용산구', '02-615-1282', '010-7333-8964', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 213, TO_TIMESTAMP('2022-04-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (417, TO_TIMESTAMP('2022-04-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(417, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (417, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-04-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (418, TO_TIMESTAMP('2022-04-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(418, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(418, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(418, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(418, 4, 1);
INSERT INTO payment_info VALUES (418, 10000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-04-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (419, TO_TIMESTAMP('2022-04-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(419, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(419, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (419, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍지호', '430810-2222222', '서울특별시 마포구', '02-519-3409', '010-9451-5757', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 214, TO_TIMESTAMP('2022-04-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (420, TO_TIMESTAMP('2022-04-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(420, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(420, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (420, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 99, TO_TIMESTAMP('2022-04-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (421, TO_TIMESTAMP('2022-04-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(421, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (421, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장지훈', '710818-2222222', '서울특별시 강북구', '02-877-2276', '010-1376-6731', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 215, TO_TIMESTAMP('2022-04-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (422, TO_TIMESTAMP('2022-04-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(422, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(422, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(422, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (422, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장아린', '200603-1111111', '서울특별시 관악구', '02-644-6179', '010-9496-6255', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 216, TO_TIMESTAMP('2022-04-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (423, TO_TIMESTAMP('2022-04-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(423, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(423, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(423, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(423, 9, 3);
INSERT INTO prescribed_treatments VALUES(423, 5, 2);
INSERT INTO payment_info VALUES (423, 30000, 600000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 161, TO_TIMESTAMP('2022-04-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (424, TO_TIMESTAMP('2022-04-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(424, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(424, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (424, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임윤아', '620420-1111111', '서울특별시 영등포구', '02-674-3321', '010-7786-5487', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 217, TO_TIMESTAMP('2022-04-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (425, TO_TIMESTAMP('2022-04-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(425, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (425, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-04-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (426, TO_TIMESTAMP('2022-04-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(426, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (426, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정서율', '041109-3333333', '서울특별시 강동구', '02-708-4937', '010-7858-9066', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 218, TO_TIMESTAMP('2022-04-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (427, TO_TIMESTAMP('2022-04-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (427, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 94, TO_TIMESTAMP('2022-04-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (428, TO_TIMESTAMP('2022-04-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(428, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (428, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 49, TO_TIMESTAMP('2022-04-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (429, TO_TIMESTAMP('2022-04-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(429, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (429, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정서준', '200223-4444444', '서울특별시 노원구', '02-282-2901', '010-5854-1076', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 219, TO_TIMESTAMP('2022-04-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (430, TO_TIMESTAMP('2022-04-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(430, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(430, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(430, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(430, 7, 1);
INSERT INTO prescribed_treatments VALUES(430, 6, 1);
INSERT INTO payment_info VALUES (430, 15000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 122, TO_TIMESTAMP('2022-04-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (431, TO_TIMESTAMP('2022-04-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (431, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박시현', '240402-1111111', '서울특별시 도봉구', '02-743-1846', '010-5795-8067', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 220, TO_TIMESTAMP('2022-04-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (432, TO_TIMESTAMP('2022-04-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(432, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (432, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 183, TO_TIMESTAMP('2022-04-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (433, TO_TIMESTAMP('2022-04-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(433, 5, 3);
INSERT INTO payment_info VALUES (433, 3000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허수호', '591127-1111111', '서울특별시 관악구', '02-624-3689', '010-4571-3857', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 221, TO_TIMESTAMP('2022-05-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (434, TO_TIMESTAMP('2022-05-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (434, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-05-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (435, TO_TIMESTAMP('2022-05-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (435, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정윤아', '120706-3333333', '서울특별시 도봉구', '02-525-9139', '010-9108-7674', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 222, TO_TIMESTAMP('2022-05-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (436, TO_TIMESTAMP('2022-05-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(436, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (436, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-05-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (437, TO_TIMESTAMP('2022-05-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(437, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(437, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(437, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (437, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강지호', '260206-1111111', '서울특별시 노원구', '02-650-6686', '010-4500-9952', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 223, TO_TIMESTAMP('2022-05-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (438, TO_TIMESTAMP('2022-05-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(438, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(438, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(438, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (438, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 66, TO_TIMESTAMP('2022-05-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (439, TO_TIMESTAMP('2022-05-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(439, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(439, 500, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(439, 5, 1);
INSERT INTO prescribed_treatments VALUES(439, 3, 2);
INSERT INTO payment_info VALUES (439, 30000, 170000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허다은', '210421-1111111', '서울특별시 노원구', '02-124-5541', '010-7409-2610', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 224, TO_TIMESTAMP('2022-05-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (440, TO_TIMESTAMP('2022-05-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(440, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(440, 700, 1, 2, 5);
INSERT INTO payment_info VALUES (440, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박예나', '750226-2222222', '서울특별시 노원구', '02-846-4312', '010-4198-8940', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 225, TO_TIMESTAMP('2022-05-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (441, TO_TIMESTAMP('2022-05-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(441, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(441, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(441, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (441, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 75, TO_TIMESTAMP('2022-05-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (442, TO_TIMESTAMP('2022-05-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(442, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(442, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(442, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (442, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정채원', '140103-4444444', '서울특별시 노원구', '02-799-5717', '010-3627-9540', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 226, TO_TIMESTAMP('2022-05-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (443, TO_TIMESTAMP('2022-05-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(443, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(443, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (443, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2022-05-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (444, TO_TIMESTAMP('2022-05-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(444, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(444, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(444, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (444, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조서진', '260603-2222222', '서울특별시 동대문구', '02-934-6113', '010-6650-9740', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 227, TO_TIMESTAMP('2022-05-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (445, TO_TIMESTAMP('2022-05-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(445, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(445, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(445, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (445, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 147, TO_TIMESTAMP('2022-05-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (446, TO_TIMESTAMP('2022-05-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(446, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(446, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (446, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍시후', '721017-2222222', '서울특별시 종로구', '02-450-6416', '010-7561-1329', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 228, TO_TIMESTAMP('2022-05-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (447, TO_TIMESTAMP('2022-05-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(447, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (447, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 24, TO_TIMESTAMP('2022-05-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (448, TO_TIMESTAMP('2022-05-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(448, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(448, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(448, 700, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(448, 10, 2);
INSERT INTO prescribed_treatments VALUES(448, 8, 3);
INSERT INTO payment_info VALUES (448, 30000, 610000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 95, TO_TIMESTAMP('2022-05-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (449, TO_TIMESTAMP('2022-05-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(449, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (449, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박민재', '351019-1111111', '서울특별시 강북구', '02-498-1669', '010-7368-4464', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 229, TO_TIMESTAMP('2022-05-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (450, TO_TIMESTAMP('2022-05-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(450, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (450, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-05-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (451, TO_TIMESTAMP('2022-05-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(451, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(451, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(451, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (451, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허연서', '141028-4444444', '서울특별시 양천구', '02-285-3241', '010-4262-1646', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 230, TO_TIMESTAMP('2022-05-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (452, TO_TIMESTAMP('2022-05-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(452, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(452, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(452, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (452, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 134, TO_TIMESTAMP('2022-05-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (453, TO_TIMESTAMP('2022-05-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(453, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (453, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-05-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (454, TO_TIMESTAMP('2022-05-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(454, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(454, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (454, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임수호', '331122-1111111', '서울특별시 강북구', '02-248-5898', '010-3408-9057', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 231, TO_TIMESTAMP('2022-05-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (455, TO_TIMESTAMP('2022-05-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(455, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(455, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (455, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이윤우', '050711-4444444', '서울특별시 동작구', '02-224-3121', '010-3376-4546', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 232, TO_TIMESTAMP('2022-05-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (456, TO_TIMESTAMP('2022-05-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (456, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-05-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (457, TO_TIMESTAMP('2022-05-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(457, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(457, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(457, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (457, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허다은', '410120-2222222', '서울특별시 성동구', '02-585-6015', '010-4085-2882', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 233, TO_TIMESTAMP('2022-05-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (458, TO_TIMESTAMP('2022-05-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(458, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(458, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (458, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 155, TO_TIMESTAMP('2022-05-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (459, TO_TIMESTAMP('2022-05-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (459, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임아린', '380128-2222222', '서울특별시 강동구', '02-945-9352', '010-1948-5608', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 234, TO_TIMESTAMP('2022-05-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (460, TO_TIMESTAMP('2022-05-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(460, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(460, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(460, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (460, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서영', '410303-2222222', '서울특별시 서초구', '02-359-4808', '010-4367-9658', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 235, TO_TIMESTAMP('2022-05-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (461, TO_TIMESTAMP('2022-05-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(461, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (461, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 214, TO_TIMESTAMP('2022-05-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (462, TO_TIMESTAMP('2022-05-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (462, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 54, TO_TIMESTAMP('2022-05-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (463, TO_TIMESTAMP('2022-05-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(463, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(463, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(463, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (463, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김정우', '660310-1111111', '서울특별시 종로구', '02-706-8381', '010-8579-9140', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 236, TO_TIMESTAMP('2022-05-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (464, TO_TIMESTAMP('2022-05-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (464, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 196, TO_TIMESTAMP('2022-05-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (465, TO_TIMESTAMP('2022-05-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(465, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(465, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (465, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임유나', '930727-1111111', '서울특별시 서초구', '02-454-7544', '010-8907-6132', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 237, TO_TIMESTAMP('2022-05-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (466, TO_TIMESTAMP('2022-05-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (466, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박시아', '471201-2222222', '서울특별시 강동구', '02-443-9187', '010-5443-1701', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 238, TO_TIMESTAMP('2022-05-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (467, TO_TIMESTAMP('2022-05-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(467, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(467, 1, 1);
INSERT INTO payment_info VALUES (467, 10000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 78, TO_TIMESTAMP('2022-05-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (468, TO_TIMESTAMP('2022-05-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(468, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(468, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (468, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예은', '220115-2222222', '서울특별시 성북구', '02-753-9724', '010-2387-1015', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 239, TO_TIMESTAMP('2022-05-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (469, TO_TIMESTAMP('2022-05-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(469, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(469, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(469, 100, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(469, 1, 1);
INSERT INTO payment_info VALUES (469, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 131, TO_TIMESTAMP('2022-05-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (470, TO_TIMESTAMP('2022-05-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(470, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (470, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강연서', '370501-1111111', '서울특별시 성동구', '02-959-1113', '010-6125-5245', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 240, TO_TIMESTAMP('2022-05-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (471, TO_TIMESTAMP('2022-05-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(471, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(471, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (471, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 211, TO_TIMESTAMP('2022-05-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (472, TO_TIMESTAMP('2022-05-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(472, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(472, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (472, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 198, TO_TIMESTAMP('2022-05-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (473, TO_TIMESTAMP('2022-05-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(473, 4, 1);
INSERT INTO payment_info VALUES (473, 10000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박건우', '420417-2222222', '서울특별시 관악구', '02-434-3961', '010-2150-2532', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 241, TO_TIMESTAMP('2022-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (474, TO_TIMESTAMP('2022-05-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (474, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 211, TO_TIMESTAMP('2022-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (475, TO_TIMESTAMP('2022-05-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(475, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(475, 500, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(475, 10, 2);
INSERT INTO payment_info VALUES (475, 15000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 164, TO_TIMESTAMP('2022-05-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (476, TO_TIMESTAMP('2022-05-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(476, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(476, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(476, 700, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(476, 9, 2);
INSERT INTO payment_info VALUES (476, 10000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지유', '320321-2222222', '서울특별시 영등포구', '02-981-5503', '010-7018-2147', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 242, TO_TIMESTAMP('2022-05-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (477, TO_TIMESTAMP('2022-05-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(477, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (477, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민재', '551008-2222222', '서울특별시 관악구', '02-587-2350', '010-2094-9268', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 243, TO_TIMESTAMP('2022-05-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (478, TO_TIMESTAMP('2022-05-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (478, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김준영', '491028-2222222', '서울특별시 금천구', '02-844-8484', '010-1661-3777', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 244, TO_TIMESTAMP('2022-05-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (479, TO_TIMESTAMP('2022-05-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(479, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(479, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(479, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (479, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김윤아', '300316-1111111', '서울특별시 강남구', '02-206-1234', '010-8563-5984', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 245, TO_TIMESTAMP('2022-05-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (480, TO_TIMESTAMP('2022-05-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(480, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(480, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(480, 5, 2);
INSERT INTO payment_info VALUES (480, 10000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 138, TO_TIMESTAMP('2022-05-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (481, TO_TIMESTAMP('2022-05-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(481, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (481, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박지후', '280221-1111111', '서울특별시 동대문구', '02-492-1969', '010-6224-4007', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 246, TO_TIMESTAMP('2022-05-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (482, TO_TIMESTAMP('2022-05-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(482, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(482, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(482, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (482, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 160, TO_TIMESTAMP('2022-05-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (483, TO_TIMESTAMP('2022-05-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(483, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(483, 1000, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(483, 7, 3);
INSERT INTO prescribed_treatments VALUES(483, 2, 1);
INSERT INTO payment_info VALUES (483, 3000, 500000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최윤아', '310818-2222222', '서울특별시 송파구', '02-184-2297', '010-4240-2582', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 247, TO_TIMESTAMP('2022-05-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (484, TO_TIMESTAMP('2022-05-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(484, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(484, 2, 3);
INSERT INTO prescribed_treatments VALUES(484, 9, 3);
INSERT INTO payment_info VALUES (484, 5000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 121, TO_TIMESTAMP('2022-05-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (485, TO_TIMESTAMP('2022-05-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(485, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (485, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임하윤', '800927-1111111', '서울특별시 중구', '02-419-4583', '010-3351-5068', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 248, TO_TIMESTAMP('2022-05-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (486, TO_TIMESTAMP('2022-05-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(486, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(486, 300, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(486, 10, 3);
INSERT INTO prescribed_treatments VALUES(486, 9, 2);
INSERT INTO payment_info VALUES (486, 5000, 890000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-05-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (487, TO_TIMESTAMP('2022-05-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(487, 800, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(487, 5, 3);
INSERT INTO prescribed_treatments VALUES(487, 9, 2);
INSERT INTO payment_info VALUES (487, 5000, 650000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박하린', '450118-1111111', '서울특별시 영등포구', '02-199-7940', '010-9317-1374', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 249, TO_TIMESTAMP('2022-05-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (488, TO_TIMESTAMP('2022-05-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(488, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (488, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 104, TO_TIMESTAMP('2022-05-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (489, TO_TIMESTAMP('2022-05-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(489, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(489, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (489, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조이준', '661228-2222222', '서울특별시 강남구', '02-241-8339', '010-1012-8887', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 250, TO_TIMESTAMP('2022-05-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (490, TO_TIMESTAMP('2022-05-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(490, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (490, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 67, TO_TIMESTAMP('2022-05-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (491, TO_TIMESTAMP('2022-05-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (491, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최이준', '350605-1111111', '서울특별시 도봉구', '02-393-2630', '010-4610-3972', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 251, TO_TIMESTAMP('2022-05-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (492, TO_TIMESTAMP('2022-05-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(492, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (492, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허수아', '111110-4444444', '서울특별시 마포구', '02-196-2616', '010-4826-2131', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 252, TO_TIMESTAMP('2022-05-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (493, TO_TIMESTAMP('2022-05-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(493, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (493, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이은서', '440311-1111111', '서울특별시 동작구', '02-828-5337', '010-2711-5189', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 253, TO_TIMESTAMP('2022-05-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (494, TO_TIMESTAMP('2022-05-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (494, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 167, TO_TIMESTAMP('2022-05-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (495, TO_TIMESTAMP('2022-05-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (495, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김윤아', '210909-3333333', '서울특별시 서초구', '02-353-7097', '010-8416-7585', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 254, TO_TIMESTAMP('2022-05-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (496, TO_TIMESTAMP('2022-05-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (496, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 148, TO_TIMESTAMP('2022-05-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (497, TO_TIMESTAMP('2022-05-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(497, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(497, 5, 1);
INSERT INTO prescribed_treatments VALUES(497, 7, 1);
INSERT INTO payment_info VALUES (497, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김시윤', '540204-2222222', '서울특별시 관악구', '02-221-6614', '010-5398-1168', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 255, TO_TIMESTAMP('2022-05-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (498, TO_TIMESTAMP('2022-05-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(498, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(498, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(498, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (498, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임연우', '710919-2222222', '서울특별시 용산구', '02-879-2963', '010-1332-5171', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 256, TO_TIMESTAMP('2022-05-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (499, TO_TIMESTAMP('2022-05-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(499, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(499, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (499, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2022-05-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (500, TO_TIMESTAMP('2022-05-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(500, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (500, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 246, TO_TIMESTAMP('2022-05-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (501, TO_TIMESTAMP('2022-05-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(501, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (501, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지율', '830716-2222222', '서울특별시 영등포구', '02-236-6186', '010-3918-4437', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 257, TO_TIMESTAMP('2022-05-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (502, TO_TIMESTAMP('2022-05-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (502, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유빈', '720325-1111111', '서울특별시 은평구', '02-431-1967', '010-1012-9182', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-05-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (503, TO_TIMESTAMP('2022-05-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (503, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최선우', '200805-4444444', '서울특별시 영등포구', '02-651-5148', '010-9710-4448', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 259, TO_TIMESTAMP('2022-05-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (504, TO_TIMESTAMP('2022-05-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(504, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(504, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(504, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (504, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 59, TO_TIMESTAMP('2022-05-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (505, TO_TIMESTAMP('2022-05-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(505, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(505, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(505, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (505, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 70, TO_TIMESTAMP('2022-05-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (506, TO_TIMESTAMP('2022-05-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(506, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(506, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (506, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김연서', '140414-4444444', '서울특별시 마포구', '02-801-4434', '010-5943-5174', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 260, TO_TIMESTAMP('2022-05-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (507, TO_TIMESTAMP('2022-05-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(507, 1000, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(507, 9, 2);
INSERT INTO payment_info VALUES (507, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 213, TO_TIMESTAMP('2022-05-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (508, TO_TIMESTAMP('2022-05-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(508, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(508, 2, 1);
INSERT INTO payment_info VALUES (508, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이채윤', '620910-2222222', '서울특별시 은평구', '02-556-7179', '010-3469-9010', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 261, TO_TIMESTAMP('2022-05-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (509, TO_TIMESTAMP('2022-05-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(509, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(509, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (509, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 116, TO_TIMESTAMP('2022-05-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (510, TO_TIMESTAMP('2022-05-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (510, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 192, TO_TIMESTAMP('2022-05-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (511, TO_TIMESTAMP('2022-05-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(511, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(511, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(511, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (511, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유준', '050718-4444444', '서울특별시 동대문구', '02-608-9849', '010-2038-7917', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 262, TO_TIMESTAMP('2022-05-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (512, TO_TIMESTAMP('2022-05-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(512, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (512, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 255, TO_TIMESTAMP('2022-05-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (513, TO_TIMESTAMP('2022-05-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(513, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(513, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (513, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정윤우', '691020-1111111', '서울특별시 강서구', '02-567-5467', '010-1008-2433', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 263, TO_TIMESTAMP('2022-05-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (514, TO_TIMESTAMP('2022-05-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(514, 300, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(514, 7, 3);
INSERT INTO prescribed_treatments VALUES(514, 2, 1);
INSERT INTO payment_info VALUES (514, 30000, 500000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 96, TO_TIMESTAMP('2022-05-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (515, TO_TIMESTAMP('2022-05-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(515, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(515, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(515, 5, 1);
INSERT INTO payment_info VALUES (515, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정시아', '200317-4444444', '서울특별시 광진구', '02-452-4203', '010-8616-8772', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 264, TO_TIMESTAMP('2022-05-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (516, TO_TIMESTAMP('2022-05-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(516, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(516, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(516, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(516, 6, 3);
INSERT INTO payment_info VALUES (516, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2022-05-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (517, TO_TIMESTAMP('2022-05-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(517, 3, 1);
INSERT INTO prescribed_treatments VALUES(517, 9, 2);
INSERT INTO payment_info VALUES (517, 15000, 210000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박도윤', '621016-1111111', '서울특별시 양천구', '02-914-7096', '010-3614-8318', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 265, TO_TIMESTAMP('2022-05-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (518, TO_TIMESTAMP('2022-05-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(518, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (518, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시은', '770310-2222222', '서울특별시 서대문구', '02-186-4971', '010-8324-9793', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 266, TO_TIMESTAMP('2022-05-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (519, TO_TIMESTAMP('2022-05-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(519, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(519, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (519, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-05-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (520, TO_TIMESTAMP('2022-05-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (520, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 190, TO_TIMESTAMP('2022-05-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (521, TO_TIMESTAMP('2022-05-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (521, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김연우', '030510-4444444', '서울특별시 도봉구', '02-162-9896', '010-8276-9539', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 267, TO_TIMESTAMP('2022-05-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (522, TO_TIMESTAMP('2022-05-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(522, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(522, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (522, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지율', '950724-1111111', '서울특별시 강북구', '02-299-8721', '010-1509-2725', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 268, TO_TIMESTAMP('2022-05-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (523, TO_TIMESTAMP('2022-05-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(523, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(523, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(523, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (523, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이연우', '990316-2222222', '서울특별시 동대문구', '02-439-7668', '010-2699-7823', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 269, TO_TIMESTAMP('2022-05-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (524, TO_TIMESTAMP('2022-05-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(524, 6, 2);
INSERT INTO payment_info VALUES (524, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 61, TO_TIMESTAMP('2022-05-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (525, TO_TIMESTAMP('2022-05-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(525, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(525, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(525, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (525, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최수아', '150313-4444444', '서울특별시 관악구', '02-913-8835', '010-7663-1341', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 270, TO_TIMESTAMP('2022-05-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (526, TO_TIMESTAMP('2022-05-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(526, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(526, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (526, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최소윤', '710114-1111111', '서울특별시 서초구', '02-605-1894', '010-2446-4480', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 271, TO_TIMESTAMP('2022-05-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (527, TO_TIMESTAMP('2022-05-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(527, 100, 1, 3, 5);
INSERT INTO payment_info VALUES (527, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김수연', '080713-3333333', '서울특별시 양천구', '02-985-5093', '010-4898-4165', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 272, TO_TIMESTAMP('2022-05-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (528, TO_TIMESTAMP('2022-05-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (528, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 24, TO_TIMESTAMP('2022-05-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (529, TO_TIMESTAMP('2022-05-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(529, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(529, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (529, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 223, TO_TIMESTAMP('2022-05-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (530, TO_TIMESTAMP('2022-05-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(530, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(530, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(530, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(530, 7, 3);
INSERT INTO prescribed_treatments VALUES(530, 5, 2);
INSERT INTO payment_info VALUES (530, 5000, 750000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최하은', '270913-2222222', '서울특별시 구로구', '02-873-2874', '010-5604-5915', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 273, TO_TIMESTAMP('2022-05-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (531, TO_TIMESTAMP('2022-05-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(531, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(531, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(531, 9, 1);
INSERT INTO prescribed_treatments VALUES(531, 3, 1);
INSERT INTO payment_info VALUES (531, 3000, 110000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 164, TO_TIMESTAMP('2022-05-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (532, TO_TIMESTAMP('2022-05-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(532, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(532, 8, 2);
INSERT INTO payment_info VALUES (532, 5000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강지윤', '600919-2222222', '서울특별시 강서구', '02-928-8329', '010-5159-9099', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 274, TO_TIMESTAMP('2022-05-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (533, TO_TIMESTAMP('2022-05-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(533, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(533, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (533, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 64, TO_TIMESTAMP('2022-05-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (534, TO_TIMESTAMP('2022-05-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(534, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(534, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (534, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 116, TO_TIMESTAMP('2022-05-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (535, TO_TIMESTAMP('2022-05-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(535, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(535, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(535, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(535, 1, 1);
INSERT INTO payment_info VALUES (535, 10000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최시우', '600225-2222222', '서울특별시 금천구', '02-550-8557', '010-1362-5399', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 275, TO_TIMESTAMP('2022-06-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (536, TO_TIMESTAMP('2022-06-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (536, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예린', '780527-2222222', '서울특별시 성북구', '02-929-7885', '010-1186-2939', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 276, TO_TIMESTAMP('2022-06-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (537, TO_TIMESTAMP('2022-06-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(537, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(537, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(537, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (537, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 212, TO_TIMESTAMP('2022-06-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (538, TO_TIMESTAMP('2022-06-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(538, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(538, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(538, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (538, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조주원', '980312-2222222', '서울특별시 서초구', '02-729-5890', '010-7791-1048', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 277, TO_TIMESTAMP('2022-06-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (539, TO_TIMESTAMP('2022-06-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (539, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임채은', '110507-4444444', '서울특별시 강동구', '02-884-9615', '010-9435-1764', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 278, TO_TIMESTAMP('2022-06-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (540, TO_TIMESTAMP('2022-06-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (540, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-06-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (541, TO_TIMESTAMP('2022-06-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(541, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (541, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장예진', '140724-4444444', '서울특별시 금천구', '02-818-7493', '010-6996-1775', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 279, TO_TIMESTAMP('2022-06-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (542, TO_TIMESTAMP('2022-06-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(542, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(542, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (542, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 238, TO_TIMESTAMP('2022-06-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (543, TO_TIMESTAMP('2022-06-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(543, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(543, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(543, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(543, 5, 1);
INSERT INTO payment_info VALUES (543, 15000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 94, TO_TIMESTAMP('2022-06-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (544, TO_TIMESTAMP('2022-06-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(544, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(544, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (544, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장이준', '481016-2222222', '서울특별시 동작구', '02-246-2445', '010-1019-9635', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 280, TO_TIMESTAMP('2022-06-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (545, TO_TIMESTAMP('2022-06-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (545, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 5, TO_TIMESTAMP('2022-06-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (546, TO_TIMESTAMP('2022-06-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(546, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(546, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(546, 8, 2);
INSERT INTO prescribed_treatments VALUES(546, 9, 2);
INSERT INTO payment_info VALUES (546, 30000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 235, TO_TIMESTAMP('2022-06-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (547, TO_TIMESTAMP('2022-06-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(547, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(547, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (547, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장채은', '700705-1111111', '서울특별시 성북구', '02-454-8341', '010-3161-6481', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 281, TO_TIMESTAMP('2022-06-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (548, TO_TIMESTAMP('2022-06-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (548, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 122, TO_TIMESTAMP('2022-06-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (549, TO_TIMESTAMP('2022-06-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(549, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(549, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(549, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (549, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 276, TO_TIMESTAMP('2022-06-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (550, TO_TIMESTAMP('2022-06-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (550, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 210, TO_TIMESTAMP('2022-06-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (551, TO_TIMESTAMP('2022-06-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(551, 800, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(551, 5, 3);
INSERT INTO payment_info VALUES (551, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박민성', '591001-2222222', '서울특별시 성동구', '02-412-1232', '010-5232-4855', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 282, TO_TIMESTAMP('2022-06-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (552, TO_TIMESTAMP('2022-06-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(552, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(552, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (552, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 89, TO_TIMESTAMP('2022-06-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (553, TO_TIMESTAMP('2022-06-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(553, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(553, 1, 2);
INSERT INTO prescribed_treatments VALUES(553, 8, 1);
INSERT INTO payment_info VALUES (553, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 277, TO_TIMESTAMP('2022-06-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (554, TO_TIMESTAMP('2022-06-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(554, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (554, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조지후', '450705-1111111', '서울특별시 강남구', '02-730-2400', '010-2016-1630', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 283, TO_TIMESTAMP('2022-06-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (555, TO_TIMESTAMP('2022-06-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(555, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(555, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(555, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (555, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍준서', '311115-1111111', '서울특별시 용산구', '02-746-9265', '010-9255-4764', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 284, TO_TIMESTAMP('2022-06-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (556, TO_TIMESTAMP('2022-06-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(556, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(556, 4, 3);
INSERT INTO prescribed_treatments VALUES(556, 2, 1);
INSERT INTO payment_info VALUES (556, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-06-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (557, TO_TIMESTAMP('2022-06-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(557, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(557, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(557, 4, 2);
INSERT INTO prescribed_treatments VALUES(557, 3, 3);
INSERT INTO payment_info VALUES (557, 10000, 130000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서영', '410924-2222222', '서울특별시 동작구', '02-199-8666', '010-4089-5072', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 285, TO_TIMESTAMP('2022-06-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (558, TO_TIMESTAMP('2022-06-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(558, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(558, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (558, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 277, TO_TIMESTAMP('2022-06-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (559, TO_TIMESTAMP('2022-06-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(559, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(559, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (559, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허아윤', '431016-1111111', '서울특별시 은평구', '02-471-4938', '010-5966-9146', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 286, TO_TIMESTAMP('2022-06-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (560, TO_TIMESTAMP('2022-06-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(560, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(560, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(560, 300, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(560, 3, 2);
INSERT INTO prescribed_treatments VALUES(560, 8, 1);
INSERT INTO payment_info VALUES (560, 10000, 70000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 139, TO_TIMESTAMP('2022-06-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (561, TO_TIMESTAMP('2022-06-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(561, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(561, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(561, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(561, 6, 1);
INSERT INTO prescribed_treatments VALUES(561, 10, 1);
INSERT INTO payment_info VALUES (561, 5000, 280000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시연', '891220-1111111', '서울특별시 동작구', '02-147-1002', '010-5473-2786', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 287, TO_TIMESTAMP('2022-06-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (562, TO_TIMESTAMP('2022-06-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(562, 600, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(562, 9, 1);
INSERT INTO payment_info VALUES (562, 3000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 127, TO_TIMESTAMP('2022-06-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (563, TO_TIMESTAMP('2022-06-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(563, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(563, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(563, 400, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(563, 3, 3);
INSERT INTO prescribed_treatments VALUES(563, 2, 2);
INSERT INTO payment_info VALUES (563, 30000, 130000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 160, TO_TIMESTAMP('2022-06-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (564, TO_TIMESTAMP('2022-06-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(564, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(564, 600, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(564, 5, 3);
INSERT INTO payment_info VALUES (564, 10000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정소율', '080806-3333333', '서울특별시 노원구', '02-465-8061', '010-6679-8497', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 288, TO_TIMESTAMP('2022-06-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (565, TO_TIMESTAMP('2022-06-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(565, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (565, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 11, TO_TIMESTAMP('2022-06-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (566, TO_TIMESTAMP('2022-06-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(566, 7, 2);
INSERT INTO payment_info VALUES (566, 30000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장주원', '190807-3333333', '서울특별시 중구', '02-283-6780', '010-4553-5103', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 289, TO_TIMESTAMP('2022-06-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (567, TO_TIMESTAMP('2022-06-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(567, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(567, 100, 1, 2, 3);
INSERT INTO payment_info VALUES (567, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 47, TO_TIMESTAMP('2022-06-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (568, TO_TIMESTAMP('2022-06-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(568, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(568, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (568, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지민', '050317-3333333', '서울특별시 마포구', '02-790-4308', '010-7576-7599', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 290, TO_TIMESTAMP('2022-06-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (569, TO_TIMESTAMP('2022-06-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(569, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(569, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(569, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (569, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 106, TO_TIMESTAMP('2022-06-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (570, TO_TIMESTAMP('2022-06-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(570, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(570, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(570, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(570, 1, 2);
INSERT INTO payment_info VALUES (570, 3000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장하율', '210415-4444444', '서울특별시 도봉구', '02-852-5812', '010-6536-1018', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 291, TO_TIMESTAMP('2022-06-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (571, TO_TIMESTAMP('2022-06-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(571, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(571, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(571, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(571, 10, 2);
INSERT INTO prescribed_treatments VALUES(571, 1, 3);
INSERT INTO payment_info VALUES (571, 15000, 760000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시은', '850725-2222222', '서울특별시 서초구', '02-750-4453', '010-6043-3726', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 292, TO_TIMESTAMP('2022-06-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (572, TO_TIMESTAMP('2022-06-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(572, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(572, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(572, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(572, 7, 2);
INSERT INTO payment_info VALUES (572, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 205, TO_TIMESTAMP('2022-06-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (573, TO_TIMESTAMP('2022-06-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_treatments VALUES(573, 7, 3);
INSERT INTO payment_info VALUES (573, 15000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 171, TO_TIMESTAMP('2022-06-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (574, TO_TIMESTAMP('2022-06-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(574, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(574, 200, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(574, 7, 1);
INSERT INTO prescribed_treatments VALUES(574, 1, 1);
INSERT INTO payment_info VALUES (574, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 240, TO_TIMESTAMP('2022-06-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (575, TO_TIMESTAMP('2022-06-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(575, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (575, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박채은', '830827-1111111', '서울특별시 마포구', '02-362-7287', '010-1074-8322', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 293, TO_TIMESTAMP('2022-06-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (576, TO_TIMESTAMP('2022-06-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(576, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (576, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 190, TO_TIMESTAMP('2022-06-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (577, TO_TIMESTAMP('2022-06-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(577, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(577, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(577, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (577, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 87, TO_TIMESTAMP('2022-06-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (578, TO_TIMESTAMP('2022-06-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(578, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (578, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 14, TO_TIMESTAMP('2022-06-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (579, TO_TIMESTAMP('2022-06-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(579, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(579, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (579, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 137, TO_TIMESTAMP('2022-06-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (580, TO_TIMESTAMP('2022-06-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(580, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (580, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예원', '310602-2222222', '서울특별시 강남구', '02-881-4616', '010-4404-1464', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 294, TO_TIMESTAMP('2022-06-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (581, TO_TIMESTAMP('2022-06-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(581, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(581, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(581, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (581, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예서', '220501-2222222', '서울특별시 성동구', '02-867-7899', '010-6516-7662', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 295, TO_TIMESTAMP('2022-06-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (582, TO_TIMESTAMP('2022-06-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(582, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(582, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (582, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 145, TO_TIMESTAMP('2022-06-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (583, TO_TIMESTAMP('2022-06-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(583, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(583, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (583, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 161, TO_TIMESTAMP('2022-06-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (584, TO_TIMESTAMP('2022-06-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (584, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 236, TO_TIMESTAMP('2022-06-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (585, TO_TIMESTAMP('2022-06-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(585, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(585, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(585, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (585, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정수호', '541010-1111111', '서울특별시 강북구', '02-240-9674', '010-2819-8176', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 296, TO_TIMESTAMP('2022-06-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (586, TO_TIMESTAMP('2022-06-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(586, 9, 2);
INSERT INTO payment_info VALUES (586, 10000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 231, TO_TIMESTAMP('2022-06-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (587, TO_TIMESTAMP('2022-06-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (587, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강준우', '810306-2222222', '서울특별시 종로구', '02-582-8504', '010-6563-1148', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 297, TO_TIMESTAMP('2022-06-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (588, TO_TIMESTAMP('2022-06-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (588, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임수연', '770822-2222222', '서울특별시 노원구', '02-400-3390', '010-4164-1266', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 298, TO_TIMESTAMP('2022-06-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (589, TO_TIMESTAMP('2022-06-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (589, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 234, TO_TIMESTAMP('2022-06-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (590, TO_TIMESTAMP('2022-06-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(590, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (590, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허하진', '960727-1111111', '서울특별시 중구', '02-711-4939', '010-2245-8390', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 299, TO_TIMESTAMP('2022-06-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (591, TO_TIMESTAMP('2022-06-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (591, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 151, TO_TIMESTAMP('2022-06-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (592, TO_TIMESTAMP('2022-06-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(592, 100, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(592, 9, 3);
INSERT INTO payment_info VALUES (592, 3000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 133, TO_TIMESTAMP('2022-06-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (593, TO_TIMESTAMP('2022-06-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(593, 300, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(593, 10, 1);
INSERT INTO payment_info VALUES (593, 5000, 230000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 18, TO_TIMESTAMP('2022-06-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (594, TO_TIMESTAMP('2022-06-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(594, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(594, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(594, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(594, 5, 2);
INSERT INTO prescribed_treatments VALUES(594, 2, 3);
INSERT INTO payment_info VALUES (594, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조민서', '540819-1111111', '서울특별시 동작구', '02-230-4289', '010-3922-8681', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 300, TO_TIMESTAMP('2022-06-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (595, TO_TIMESTAMP('2022-06-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(595, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (595, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 293, TO_TIMESTAMP('2022-06-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (596, TO_TIMESTAMP('2022-06-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(596, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(596, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (596, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시윤', '690105-1111111', '서울특별시 동대문구', '02-309-7750', '010-8329-9773', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 301, TO_TIMESTAMP('2022-06-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (597, TO_TIMESTAMP('2022-06-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(597, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (597, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최채은', '501019-2222222', '서울특별시 강북구', '02-828-1535', '010-8078-3778', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 302, TO_TIMESTAMP('2022-06-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (598, TO_TIMESTAMP('2022-06-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(598, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(598, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (598, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장도윤', '640611-2222222', '서울특별시 도봉구', '02-168-7533', '010-5645-6258', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 303, TO_TIMESTAMP('2022-06-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (599, TO_TIMESTAMP('2022-06-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (599, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 124, TO_TIMESTAMP('2022-06-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (600, TO_TIMESTAMP('2022-06-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(600, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (600, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이지호', '780510-1111111', '서울특별시 강동구', '02-252-1938', '010-9697-4572', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 304, TO_TIMESTAMP('2022-06-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (601, TO_TIMESTAMP('2022-06-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (601, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 175, TO_TIMESTAMP('2022-06-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (602, TO_TIMESTAMP('2022-06-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(602, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(602, 300, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(602, 6, 1);
INSERT INTO payment_info VALUES (602, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최은서', '560620-1111111', '서울특별시 강서구', '02-745-5253', '010-3306-7472', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 305, TO_TIMESTAMP('2022-06-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (603, TO_TIMESTAMP('2022-06-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(603, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(603, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(603, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (603, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 274, TO_TIMESTAMP('2022-06-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (604, TO_TIMESTAMP('2022-06-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (604, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 299, TO_TIMESTAMP('2022-06-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (605, TO_TIMESTAMP('2022-06-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(605, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(605, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (605, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임서진', '170705-4444444', '서울특별시 은평구', '02-635-3730', '010-4471-3584', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 306, TO_TIMESTAMP('2022-06-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (606, TO_TIMESTAMP('2022-06-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(606, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(606, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(606, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (606, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최현서', '090101-4444444', '서울특별시 성북구', '02-301-7591', '010-8452-8924', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 307, TO_TIMESTAMP('2022-06-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (607, TO_TIMESTAMP('2022-06-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(607, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(607, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(607, 600, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(607, 5, 3);
INSERT INTO payment_info VALUES (607, 5000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 11, TO_TIMESTAMP('2022-06-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (608, TO_TIMESTAMP('2022-06-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (608, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김다연', '040602-4444444', '서울특별시 중랑구', '02-627-8324', '010-2137-4442', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 308, TO_TIMESTAMP('2022-06-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (609, TO_TIMESTAMP('2022-06-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(609, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(609, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(609, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (609, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 90, TO_TIMESTAMP('2022-06-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (610, TO_TIMESTAMP('2022-06-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(610, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (610, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이하진', '070313-3333333', '서울특별시 중구', '02-997-2378', '010-6335-6987', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 309, TO_TIMESTAMP('2022-06-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (611, TO_TIMESTAMP('2022-06-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(611, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(611, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(611, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (611, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍우진', '700808-2222222', '서울특별시 종로구', '02-240-5052', '010-5002-4904', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 310, TO_TIMESTAMP('2022-06-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (612, TO_TIMESTAMP('2022-06-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(612, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(612, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(612, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (612, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지훈', '280822-2222222', '서울특별시 광진구', '02-326-9152', '010-4702-6643', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 311, TO_TIMESTAMP('2022-06-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (613, TO_TIMESTAMP('2022-06-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(613, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(613, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(613, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (613, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유준', '391124-1111111', '서울특별시 성동구', '02-732-1159', '010-1216-5033', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 312, TO_TIMESTAMP('2022-06-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (614, TO_TIMESTAMP('2022-06-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (614, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 9, TO_TIMESTAMP('2022-06-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (615, TO_TIMESTAMP('2022-06-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (615, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임승현', '360428-1111111', '서울특별시 중구', '02-355-9056', '010-1023-3310', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 313, TO_TIMESTAMP('2022-06-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (616, TO_TIMESTAMP('2022-06-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(616, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(616, 1, 3);
INSERT INTO payment_info VALUES (616, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 186, TO_TIMESTAMP('2022-06-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (617, TO_TIMESTAMP('2022-06-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(617, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(617, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(617, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (617, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 271, TO_TIMESTAMP('2022-06-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (618, TO_TIMESTAMP('2022-06-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(618, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(618, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (618, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박진우', '771020-2222222', '서울특별시 강북구', '02-224-5481', '010-1040-4255', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 314, TO_TIMESTAMP('2022-06-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (619, TO_TIMESTAMP('2022-06-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(619, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (619, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시은', '260105-2222222', '서울특별시 서대문구', '02-977-2329', '010-7600-2949', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 315, TO_TIMESTAMP('2022-06-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (620, TO_TIMESTAMP('2022-06-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(620, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (620, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 257, TO_TIMESTAMP('2022-06-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (621, TO_TIMESTAMP('2022-06-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(621, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (621, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정아린', '700507-2222222', '서울특별시 송파구', '02-185-5674', '010-1028-2258', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 316, TO_TIMESTAMP('2022-07-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (622, TO_TIMESTAMP('2022-07-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(622, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(622, 6, 1);
INSERT INTO payment_info VALUES (622, 10000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 187, TO_TIMESTAMP('2022-07-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (623, TO_TIMESTAMP('2022-07-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(623, 10, 2);
INSERT INTO prescribed_treatments VALUES(623, 5, 1);
INSERT INTO payment_info VALUES (623, 5000, 610000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강하은', '531026-1111111', '서울특별시 동작구', '02-202-9368', '010-6211-8497', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 317, TO_TIMESTAMP('2022-07-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (624, TO_TIMESTAMP('2022-07-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(624, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(624, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(624, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(624, 9, 3);
INSERT INTO prescribed_treatments VALUES(624, 10, 1);
INSERT INTO payment_info VALUES (624, 5000, 530000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유진', '880619-2222222', '서울특별시 관악구', '02-410-6917', '010-3509-5109', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 318, TO_TIMESTAMP('2022-07-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (625, TO_TIMESTAMP('2022-07-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (625, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박이준', '440110-1111111', '서울특별시 도봉구', '02-337-3958', '010-4978-6447', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 319, TO_TIMESTAMP('2022-07-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (626, TO_TIMESTAMP('2022-07-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(626, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(626, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (626, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍시우', '990908-2222222', '서울특별시 은평구', '02-399-4521', '010-4620-4521', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 320, TO_TIMESTAMP('2022-07-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (627, TO_TIMESTAMP('2022-07-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (627, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이연서', '770418-2222222', '서울특별시 송파구', '02-355-7507', '010-1561-3151', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 321, TO_TIMESTAMP('2022-07-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (628, TO_TIMESTAMP('2022-07-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(628, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (628, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 55, TO_TIMESTAMP('2022-07-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (629, TO_TIMESTAMP('2022-07-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (629, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 84, TO_TIMESTAMP('2022-07-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (630, TO_TIMESTAMP('2022-07-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(630, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(630, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (630, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-07-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (631, TO_TIMESTAMP('2022-07-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(631, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(631, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(631, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (631, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정건우', '760715-2222222', '서울특별시 동작구', '02-670-2608', '010-9434-2891', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 322, TO_TIMESTAMP('2022-07-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (632, TO_TIMESTAMP('2022-07-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(632, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(632, 500, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(632, 6, 2);
INSERT INTO payment_info VALUES (632, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 298, TO_TIMESTAMP('2022-07-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (633, TO_TIMESTAMP('2022-07-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(633, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(633, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (633, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박서진', '360303-1111111', '서울특별시 은평구', '02-380-6229', '010-5093-3430', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 323, TO_TIMESTAMP('2022-07-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (634, TO_TIMESTAMP('2022-07-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(634, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (634, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강예준', '790401-2222222', '서울특별시 구로구', '02-126-9720', '010-1749-5225', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 324, TO_TIMESTAMP('2022-07-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (635, TO_TIMESTAMP('2022-07-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(635, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(635, 400, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(635, 9, 2);
INSERT INTO payment_info VALUES (635, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허예진', '210123-3333333', '서울특별시 양천구', '02-744-6483', '010-2605-5401', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 325, TO_TIMESTAMP('2022-07-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (636, TO_TIMESTAMP('2022-07-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(636, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(636, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (636, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 226, TO_TIMESTAMP('2022-07-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (637, TO_TIMESTAMP('2022-07-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (637, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김시온', '160205-3333333', '서울특별시 용산구', '02-850-5709', '010-5102-8779', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 326, TO_TIMESTAMP('2022-07-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (638, TO_TIMESTAMP('2022-07-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(638, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(638, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(638, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (638, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임민준', '170905-4444444', '서울특별시 중랑구', '02-362-7564', '010-5543-5689', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 327, TO_TIMESTAMP('2022-07-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (639, TO_TIMESTAMP('2022-07-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(639, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(639, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(639, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(639, 9, 2);
INSERT INTO prescribed_treatments VALUES(639, 3, 3);
INSERT INTO payment_info VALUES (639, 10000, 230000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 158, TO_TIMESTAMP('2022-07-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (640, TO_TIMESTAMP('2022-07-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (640, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박시윤', '070705-4444444', '서울특별시 노원구', '02-864-6628', '010-2750-7874', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 328, TO_TIMESTAMP('2022-07-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (641, TO_TIMESTAMP('2022-07-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(641, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(641, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (641, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-07-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (642, TO_TIMESTAMP('2022-07-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(642, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(642, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(642, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (642, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 30, TO_TIMESTAMP('2022-07-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (643, TO_TIMESTAMP('2022-07-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(643, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(643, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (643, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시윤', '040211-4444444', '서울특별시 은평구', '02-397-5845', '010-6637-1940', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 329, TO_TIMESTAMP('2022-07-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (644, TO_TIMESTAMP('2022-07-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(644, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (644, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 314, TO_TIMESTAMP('2022-07-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (645, TO_TIMESTAMP('2022-07-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (645, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임연우', '120803-3333333', '서울특별시 강남구', '02-815-2814', '010-2577-8352', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 330, TO_TIMESTAMP('2022-07-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (646, TO_TIMESTAMP('2022-07-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(646, 1, 2);
INSERT INTO prescribed_treatments VALUES(646, 4, 1);
INSERT INTO payment_info VALUES (646, 10000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 267, TO_TIMESTAMP('2022-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (647, TO_TIMESTAMP('2022-07-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(647, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (647, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유준', '610518-1111111', '서울특별시 은평구', '02-668-2245', '010-8637-7996', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 331, TO_TIMESTAMP('2022-07-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (648, TO_TIMESTAMP('2022-07-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (648, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 79, TO_TIMESTAMP('2022-07-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (649, TO_TIMESTAMP('2022-07-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(649, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(649, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(649, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (649, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 106, TO_TIMESTAMP('2022-07-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (650, TO_TIMESTAMP('2022-07-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(650, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(650, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(650, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(650, 6, 3);
INSERT INTO payment_info VALUES (650, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임선우', '140118-4444444', '서울특별시 용산구', '02-262-7298', '010-8032-5754', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 332, TO_TIMESTAMP('2022-07-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (651, TO_TIMESTAMP('2022-07-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(651, 6, 2);
INSERT INTO prescribed_treatments VALUES(651, 4, 2);
INSERT INTO payment_info VALUES (651, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박서준', '900526-1111111', '서울특별시 서초구', '02-236-5382', '010-2701-5222', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 333, TO_TIMESTAMP('2022-07-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (652, TO_TIMESTAMP('2022-07-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(652, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (652, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임소율', '211101-1111111', '서울특별시 동작구', '02-434-5434', '010-9817-9597', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 334, TO_TIMESTAMP('2022-07-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (653, TO_TIMESTAMP('2022-07-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(653, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(653, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (653, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 241, TO_TIMESTAMP('2022-07-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (654, TO_TIMESTAMP('2022-07-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(654, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(654, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(654, 1, 1);
INSERT INTO prescribed_treatments VALUES(654, 3, 2);
INSERT INTO payment_info VALUES (654, 10000, 120000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍민서', '360316-1111111', '서울특별시 성북구', '02-701-7846', '010-7837-7237', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 335, TO_TIMESTAMP('2022-07-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (655, TO_TIMESTAMP('2022-07-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(655, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(655, 7, 2);
INSERT INTO prescribed_treatments VALUES(655, 6, 1);
INSERT INTO payment_info VALUES (655, 10000, 350000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 308, TO_TIMESTAMP('2022-07-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (656, TO_TIMESTAMP('2022-07-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(656, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(656, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(656, 4, 2);
INSERT INTO prescribed_treatments VALUES(656, 1, 2);
INSERT INTO payment_info VALUES (656, 10000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 97, TO_TIMESTAMP('2022-07-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (657, TO_TIMESTAMP('2022-07-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(657, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(657, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (657, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍유진', '991112-2222222', '서울특별시 중구', '02-205-5015', '010-3386-4181', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 336, TO_TIMESTAMP('2022-07-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (658, TO_TIMESTAMP('2022-07-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(658, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(658, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(658, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (658, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 78, TO_TIMESTAMP('2022-07-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (659, TO_TIMESTAMP('2022-07-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (659, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강예서', '340805-1111111', '서울특별시 마포구', '02-425-6008', '010-3190-9621', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 337, TO_TIMESTAMP('2022-07-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (660, TO_TIMESTAMP('2022-07-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(660, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (660, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 336, TO_TIMESTAMP('2022-07-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (661, TO_TIMESTAMP('2022-07-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(661, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(661, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (661, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강서준', '770914-2222222', '서울특별시 종로구', '02-536-5328', '010-2972-6961', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 338, TO_TIMESTAMP('2022-07-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (662, TO_TIMESTAMP('2022-07-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(662, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (662, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-07-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (663, TO_TIMESTAMP('2022-07-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(663, 3, 1);
INSERT INTO prescribed_treatments VALUES(663, 1, 2);
INSERT INTO payment_info VALUES (663, 5000, 210000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-07-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (664, TO_TIMESTAMP('2022-07-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(664, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (664, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 86, TO_TIMESTAMP('2022-07-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (665, TO_TIMESTAMP('2022-07-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(665, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(665, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(665, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(665, 7, 2);
INSERT INTO prescribed_treatments VALUES(665, 2, 1);
INSERT INTO payment_info VALUES (665, 5000, 350000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박서현', '010308-3333333', '서울특별시 노원구', '02-441-6532', '010-5987-4709', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 339, TO_TIMESTAMP('2022-07-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (666, TO_TIMESTAMP('2022-07-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(666, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(666, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(666, 1, 3);
INSERT INTO prescribed_treatments VALUES(666, 8, 3);
INSERT INTO payment_info VALUES (666, 30000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-07-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (667, TO_TIMESTAMP('2022-07-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(667, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(667, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(667, 200, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(667, 1, 3);
INSERT INTO payment_info VALUES (667, 10000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-07-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (668, TO_TIMESTAMP('2022-07-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(668, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(668, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(668, 2, 1);
INSERT INTO payment_info VALUES (668, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강시후', '870222-2222222', '서울특별시 중구', '02-951-4733', '010-4191-8245', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 340, TO_TIMESTAMP('2022-07-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (669, TO_TIMESTAMP('2022-07-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(669, 8, 3);
INSERT INTO prescribed_treatments VALUES(669, 1, 3);
INSERT INTO payment_info VALUES (669, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임선우', '460109-1111111', '서울특별시 강북구', '02-195-4997', '010-3681-5583', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 341, TO_TIMESTAMP('2022-07-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (670, TO_TIMESTAMP('2022-07-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(670, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(670, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (670, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 233, TO_TIMESTAMP('2022-07-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (671, TO_TIMESTAMP('2022-07-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(671, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(671, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (671, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 253, TO_TIMESTAMP('2022-07-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (672, TO_TIMESTAMP('2022-07-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(672, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(672, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(672, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (672, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 144, TO_TIMESTAMP('2022-07-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (673, TO_TIMESTAMP('2022-07-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (673, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 24, TO_TIMESTAMP('2022-07-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (674, TO_TIMESTAMP('2022-07-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(674, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(674, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(674, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (674, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지유', '180227-3333333', '서울특별시 중랑구', '02-592-5748', '010-2896-1042', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 342, TO_TIMESTAMP('2022-07-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (675, TO_TIMESTAMP('2022-07-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(675, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(675, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(675, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(675, 1, 1);
INSERT INTO payment_info VALUES (675, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 153, TO_TIMESTAMP('2022-07-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (676, TO_TIMESTAMP('2022-07-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (676, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장가은', '980815-2222222', '서울특별시 광진구', '02-875-7008', '010-8013-4280', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 343, TO_TIMESTAMP('2022-07-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (677, TO_TIMESTAMP('2022-07-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(677, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(677, 4, 1);
INSERT INTO payment_info VALUES (677, 3000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장시아', '861215-1111111', '서울특별시 구로구', '02-878-4458', '010-9367-1688', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 344, TO_TIMESTAMP('2022-07-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (678, TO_TIMESTAMP('2022-07-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(678, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (678, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2022-07-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (679, TO_TIMESTAMP('2022-07-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(679, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(679, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(679, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (679, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정연서', '230108-2222222', '서울특별시 노원구', '02-515-3157', '010-5173-4576', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 345, TO_TIMESTAMP('2022-07-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (680, TO_TIMESTAMP('2022-07-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(680, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(680, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(680, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (680, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 154, TO_TIMESTAMP('2022-07-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (681, TO_TIMESTAMP('2022-07-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(681, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(681, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(681, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (681, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김시온', '540710-1111111', '서울특별시 은평구', '02-101-4282', '010-9285-6432', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 346, TO_TIMESTAMP('2022-07-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (682, TO_TIMESTAMP('2022-07-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (682, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 264, TO_TIMESTAMP('2022-07-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (683, TO_TIMESTAMP('2022-07-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (683, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍예은', '360412-1111111', '서울특별시 노원구', '02-933-4128', '010-6546-4564', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 347, TO_TIMESTAMP('2022-07-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (684, TO_TIMESTAMP('2022-07-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(684, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(684, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (684, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조아인', '500216-1111111', '서울특별시 양천구', '02-877-3083', '010-2392-3506', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 348, TO_TIMESTAMP('2022-07-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (685, TO_TIMESTAMP('2022-07-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(685, 300, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(685, 7, 3);
INSERT INTO prescribed_treatments VALUES(685, 8, 1);
INSERT INTO payment_info VALUES (685, 3000, 500000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 6, TO_TIMESTAMP('2022-07-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (686, TO_TIMESTAMP('2022-07-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (686, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박소윤', '701116-2222222', '서울특별시 마포구', '02-176-9003', '010-7659-9914', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 349, TO_TIMESTAMP('2022-07-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (687, TO_TIMESTAMP('2022-07-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (687, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지아', '580821-1111111', '서울특별시 동작구', '02-609-9262', '010-2801-2561', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 350, TO_TIMESTAMP('2022-07-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (688, TO_TIMESTAMP('2022-07-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(688, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(688, 800, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(688, 1, 3);
INSERT INTO prescribed_treatments VALUES(688, 5, 1);
INSERT INTO payment_info VALUES (688, 10000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-07-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (689, TO_TIMESTAMP('2022-07-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(689, 7, 3);
INSERT INTO prescribed_treatments VALUES(689, 1, 2);
INSERT INTO payment_info VALUES (689, 15000, 650000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조현준', '421123-1111111', '서울특별시 은평구', '02-802-8381', '010-9068-9585', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 351, TO_TIMESTAMP('2022-07-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (690, TO_TIMESTAMP('2022-07-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(690, 7, 3);
INSERT INTO prescribed_treatments VALUES(690, 1, 3);
INSERT INTO payment_info VALUES (690, 5000, 750000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 268, TO_TIMESTAMP('2022-07-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (691, TO_TIMESTAMP('2022-07-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(691, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(691, 2, 2);
INSERT INTO payment_info VALUES (691, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 346, TO_TIMESTAMP('2022-07-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (692, TO_TIMESTAMP('2022-07-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(692, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(692, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (692, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시윤', '490628-1111111', '서울특별시 관악구', '02-999-4943', '010-1459-8447', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 352, TO_TIMESTAMP('2022-07-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (693, TO_TIMESTAMP('2022-07-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(693, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(693, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (693, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 329, TO_TIMESTAMP('2022-07-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (694, TO_TIMESTAMP('2022-07-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(694, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (694, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장주원', '720813-1111111', '서울특별시 광진구', '02-325-6636', '010-4098-8387', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 353, TO_TIMESTAMP('2022-07-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (695, TO_TIMESTAMP('2022-07-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(695, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (695, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 272, TO_TIMESTAMP('2022-07-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (696, TO_TIMESTAMP('2022-07-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(696, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(696, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(696, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (696, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최준혁', '370903-2222222', '서울특별시 동대문구', '02-632-3696', '010-7354-6916', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 354, TO_TIMESTAMP('2022-07-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (697, TO_TIMESTAMP('2022-07-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(697, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(697, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(697, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (697, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 212, TO_TIMESTAMP('2022-07-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (698, TO_TIMESTAMP('2022-07-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(698, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(698, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (698, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이지율', '920210-1111111', '서울특별시 구로구', '02-120-4967', '010-7990-8543', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 355, TO_TIMESTAMP('2022-07-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (699, TO_TIMESTAMP('2022-07-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(699, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(699, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(699, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (699, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 268, TO_TIMESTAMP('2022-07-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (700, TO_TIMESTAMP('2022-07-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(700, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(700, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (700, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김준영', '270201-2222222', '서울특별시 강북구', '02-682-8796', '010-9460-5028', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 356, TO_TIMESTAMP('2022-07-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (701, TO_TIMESTAMP('2022-07-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(701, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(701, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (701, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 354, TO_TIMESTAMP('2022-07-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (702, TO_TIMESTAMP('2022-07-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (702, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최하윤', '651020-2222222', '서울특별시 영등포구', '02-120-8186', '010-1115-5691', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 357, TO_TIMESTAMP('2022-07-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (703, TO_TIMESTAMP('2022-07-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(703, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(703, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(703, 9, 1);
INSERT INTO payment_info VALUES (703, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 278, TO_TIMESTAMP('2022-07-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (704, TO_TIMESTAMP('2022-07-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(704, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(704, 9, 2);
INSERT INTO prescribed_treatments VALUES(704, 5, 2);
INSERT INTO payment_info VALUES (704, 10000, 500000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김진우', '770310-2222222', '서울특별시 중구', '02-463-9832', '010-6853-4142', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 358, TO_TIMESTAMP('2022-07-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (705, TO_TIMESTAMP('2022-07-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(705, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(705, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (705, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정윤우', '721203-2222222', '서울특별시 강남구', '02-294-3094', '010-6696-7314', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 359, TO_TIMESTAMP('2022-07-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (706, TO_TIMESTAMP('2022-07-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(706, 9, 3);
INSERT INTO payment_info VALUES (706, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정주원', '221010-4444444', '서울특별시 금천구', '02-829-5104', '010-3609-1047', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 360, TO_TIMESTAMP('2022-07-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (707, TO_TIMESTAMP('2022-07-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(707, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(707, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(707, 3, 3);
INSERT INTO prescribed_treatments VALUES(707, 9, 3);
INSERT INTO payment_info VALUES (707, 5000, 330000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 50, TO_TIMESTAMP('2022-07-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (708, TO_TIMESTAMP('2022-07-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (708, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 287, TO_TIMESTAMP('2022-07-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (709, TO_TIMESTAMP('2022-07-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(709, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(709, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (709, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강하진', '160424-4444444', '서울특별시 관악구', '02-155-7943', '010-2635-3027', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 361, TO_TIMESTAMP('2022-07-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (710, TO_TIMESTAMP('2022-07-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(710, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(710, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(710, 9, 1);
INSERT INTO payment_info VALUES (710, 3000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 98, TO_TIMESTAMP('2022-07-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (711, TO_TIMESTAMP('2022-07-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(711, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(711, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(711, 3, 3);
INSERT INTO prescribed_treatments VALUES(711, 2, 1);
INSERT INTO payment_info VALUES (711, 30000, 80000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 179, TO_TIMESTAMP('2022-07-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (712, TO_TIMESTAMP('2022-07-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(712, 400, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(712, 10, 3);
INSERT INTO prescribed_treatments VALUES(712, 3, 1);
INSERT INTO payment_info VALUES (712, 10000, 700000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박이안', '290815-1111111', '서울특별시 구로구', '02-756-9574', '010-7215-6089', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 362, TO_TIMESTAMP('2022-07-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (713, TO_TIMESTAMP('2022-07-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(713, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (713, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 51, TO_TIMESTAMP('2022-07-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (714, TO_TIMESTAMP('2022-07-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(714, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(714, 500, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(714, 7, 2);
INSERT INTO payment_info VALUES (714, 10000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김윤서', '011016-3333333', '서울특별시 금천구', '02-141-6784', '010-5419-6222', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 363, TO_TIMESTAMP('2022-07-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (715, TO_TIMESTAMP('2022-07-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(715, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(715, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (715, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 121, TO_TIMESTAMP('2022-07-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (716, TO_TIMESTAMP('2022-07-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(716, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(716, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (716, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지율', '290504-2222222', '서울특별시 영등포구', '02-129-7825', '010-8294-1841', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 364, TO_TIMESTAMP('2022-07-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (717, TO_TIMESTAMP('2022-07-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(717, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(717, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(717, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (717, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 71, TO_TIMESTAMP('2022-07-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (718, TO_TIMESTAMP('2022-07-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(718, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(718, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(718, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(718, 6, 2);
INSERT INTO prescribed_treatments VALUES(718, 9, 2);
INSERT INTO payment_info VALUES (718, 10000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 155, TO_TIMESTAMP('2022-07-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (719, TO_TIMESTAMP('2022-07-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(719, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(719, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(719, 1000, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(719, 2, 2);
INSERT INTO prescribed_treatments VALUES(719, 7, 3);
INSERT INTO payment_info VALUES (719, 5000, 550000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허이준', '150927-4444444', '서울특별시 마포구', '02-213-3845', '010-8626-3304', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 365, TO_TIMESTAMP('2022-08-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (720, TO_TIMESTAMP('2022-08-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(720, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(720, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(720, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (720, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 333, TO_TIMESTAMP('2022-08-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (721, TO_TIMESTAMP('2022-08-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(721, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(721, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(721, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(721, 8, 3);
INSERT INTO payment_info VALUES (721, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김지훈', '080312-4444444', '서울특별시 서대문구', '02-196-7200', '010-6545-5288', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 366, TO_TIMESTAMP('2022-08-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (722, TO_TIMESTAMP('2022-08-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(722, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(722, 700, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(722, 1, 2);
INSERT INTO prescribed_treatments VALUES(722, 10, 2);
INSERT INTO payment_info VALUES (722, 30000, 660000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 268, TO_TIMESTAMP('2022-08-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (723, TO_TIMESTAMP('2022-08-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(723, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (723, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허준혁', '420216-1111111', '서울특별시 중랑구', '02-535-8600', '010-3737-6406', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 367, TO_TIMESTAMP('2022-08-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (724, TO_TIMESTAMP('2022-08-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (724, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 307, TO_TIMESTAMP('2022-08-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (725, TO_TIMESTAMP('2022-08-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(725, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(725, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(725, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (725, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지호', '111226-4444444', '서울특별시 금천구', '02-811-8596', '010-8275-9430', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 368, TO_TIMESTAMP('2022-08-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (726, TO_TIMESTAMP('2022-08-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(726, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(726, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (726, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 161, TO_TIMESTAMP('2022-08-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (727, TO_TIMESTAMP('2022-08-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(727, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(727, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(727, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (727, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 46, TO_TIMESTAMP('2022-08-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (728, TO_TIMESTAMP('2022-08-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(728, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(728, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(728, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (728, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 48, TO_TIMESTAMP('2022-08-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (729, TO_TIMESTAMP('2022-08-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (729, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정유준', '081020-4444444', '서울특별시 중구', '02-322-4901', '010-4000-2501', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 369, TO_TIMESTAMP('2022-08-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (730, TO_TIMESTAMP('2022-08-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(730, 400, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(730, 8, 1);
INSERT INTO payment_info VALUES (730, 3000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 353, TO_TIMESTAMP('2022-08-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (731, TO_TIMESTAMP('2022-08-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(731, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (731, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍승현', '910217-1111111', '서울특별시 마포구', '02-227-8369', '010-9287-9789', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 370, TO_TIMESTAMP('2022-08-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (732, TO_TIMESTAMP('2022-08-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(732, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(732, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (732, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강지유', '990405-1111111', '서울특별시 관악구', '02-322-9080', '010-7694-7498', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 371, TO_TIMESTAMP('2022-08-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (733, TO_TIMESTAMP('2022-08-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(733, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(733, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (733, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 35, TO_TIMESTAMP('2022-08-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (734, TO_TIMESTAMP('2022-08-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(734, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(734, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (734, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 205, TO_TIMESTAMP('2022-08-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (735, TO_TIMESTAMP('2022-08-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(735, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (735, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 355, TO_TIMESTAMP('2022-08-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (736, TO_TIMESTAMP('2022-08-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (736, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 208, TO_TIMESTAMP('2022-08-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (737, TO_TIMESTAMP('2022-08-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(737, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(737, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(737, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(737, 8, 2);
INSERT INTO prescribed_treatments VALUES(737, 9, 1);
INSERT INTO payment_info VALUES (737, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 117, TO_TIMESTAMP('2022-08-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (738, TO_TIMESTAMP('2022-08-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(738, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(738, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (738, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정아윤', '921025-2222222', '서울특별시 중구', '02-212-3499', '010-6325-8636', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 372, TO_TIMESTAMP('2022-08-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (739, TO_TIMESTAMP('2022-08-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(739, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(739, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(739, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (739, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 137, TO_TIMESTAMP('2022-08-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (740, TO_TIMESTAMP('2022-08-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(740, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(740, 4, 3);
INSERT INTO prescribed_treatments VALUES(740, 8, 1);
INSERT INTO payment_info VALUES (740, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 200, TO_TIMESTAMP('2022-08-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (741, TO_TIMESTAMP('2022-08-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(741, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(741, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(741, 600, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(741, 2, 2);
INSERT INTO prescribed_treatments VALUES(741, 1, 3);
INSERT INTO payment_info VALUES (741, 10000, 400000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정은우', '210812-1111111', '서울특별시 용산구', '02-125-7648', '010-6099-3320', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 373, TO_TIMESTAMP('2022-08-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (742, TO_TIMESTAMP('2022-08-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(742, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (742, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 167, TO_TIMESTAMP('2022-08-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (743, TO_TIMESTAMP('2022-08-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (743, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이수아', '760423-2222222', '서울특별시 구로구', '02-841-2043', '010-6369-2204', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 374, TO_TIMESTAMP('2022-08-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (744, TO_TIMESTAMP('2022-08-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(744, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(744, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (744, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조승민', '900422-1111111', '서울특별시 강동구', '02-590-9606', '010-5725-3683', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 375, TO_TIMESTAMP('2022-08-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (745, TO_TIMESTAMP('2022-08-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(745, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(745, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(745, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (745, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 235, TO_TIMESTAMP('2022-08-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (746, TO_TIMESTAMP('2022-08-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(746, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(746, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(746, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(746, 9, 2);
INSERT INTO payment_info VALUES (746, 10000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예린', '060110-3333333', '서울특별시 금천구', '02-662-1191', '010-3959-3047', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 376, TO_TIMESTAMP('2022-08-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (747, TO_TIMESTAMP('2022-08-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(747, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(747, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(747, 10, 1);
INSERT INTO payment_info VALUES (747, 5000, 230000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강윤우', '720622-2222222', '서울특별시 관악구', '02-799-6958', '010-6966-3549', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 377, TO_TIMESTAMP('2022-08-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (748, TO_TIMESTAMP('2022-08-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (748, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 173, TO_TIMESTAMP('2022-08-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (749, TO_TIMESTAMP('2022-08-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(749, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(749, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(749, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (749, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 290, TO_TIMESTAMP('2022-08-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (750, TO_TIMESTAMP('2022-08-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(750, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (750, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 161, TO_TIMESTAMP('2022-08-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (751, TO_TIMESTAMP('2022-08-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (751, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예서', '120525-4444444', '서울특별시 중구', '02-801-5186', '010-7463-5523', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 378, TO_TIMESTAMP('2022-08-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (752, TO_TIMESTAMP('2022-08-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(752, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(752, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(752, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (752, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 130, TO_TIMESTAMP('2022-08-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (753, TO_TIMESTAMP('2022-08-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (753, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장현서', '791112-1111111', '서울특별시 중랑구', '02-195-3134', '010-5394-6351', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 379, TO_TIMESTAMP('2022-08-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (754, TO_TIMESTAMP('2022-08-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(754, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (754, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 191, TO_TIMESTAMP('2022-08-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (755, TO_TIMESTAMP('2022-08-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(755, 9, 1);
INSERT INTO prescribed_treatments VALUES(755, 4, 1);
INSERT INTO payment_info VALUES (755, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 249, TO_TIMESTAMP('2022-08-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (756, TO_TIMESTAMP('2022-08-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (756, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민지', '420525-2222222', '서울특별시 성북구', '02-550-7492', '010-3434-4415', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 380, TO_TIMESTAMP('2022-08-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (757, TO_TIMESTAMP('2022-08-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(757, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(757, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (757, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 86, TO_TIMESTAMP('2022-08-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (758, TO_TIMESTAMP('2022-08-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(758, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(758, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(758, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (758, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이수호', '970624-1111111', '서울특별시 성동구', '02-793-8877', '010-9492-1112', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 381, TO_TIMESTAMP('2022-08-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (759, TO_TIMESTAMP('2022-08-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(759, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (759, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 203, TO_TIMESTAMP('2022-08-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (760, TO_TIMESTAMP('2022-08-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(760, 3, 1);
INSERT INTO payment_info VALUES (760, 10000, 10000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강지훈', '601123-2222222', '서울특별시 도봉구', '02-575-8620', '010-7605-2336', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 382, TO_TIMESTAMP('2022-08-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (761, TO_TIMESTAMP('2022-08-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(761, 6, 3);
INSERT INTO prescribed_treatments VALUES(761, 8, 1);
INSERT INTO payment_info VALUES (761, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이승우', '490810-2222222', '서울특별시 서대문구', '02-586-8821', '010-6352-7432', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 383, TO_TIMESTAMP('2022-08-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (762, TO_TIMESTAMP('2022-08-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(762, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(762, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (762, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 234, TO_TIMESTAMP('2022-08-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (763, TO_TIMESTAMP('2022-08-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(763, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (763, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍다은', '200704-1111111', '서울특별시 광진구', '02-236-5525', '010-6629-6569', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 384, TO_TIMESTAMP('2022-08-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (764, TO_TIMESTAMP('2022-08-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(764, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(764, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(764, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(764, 8, 2);
INSERT INTO payment_info VALUES (764, 10000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허정우', '230125-1111111', '서울특별시 양천구', '02-346-1249', '010-3598-6864', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 385, TO_TIMESTAMP('2022-08-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (765, TO_TIMESTAMP('2022-08-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (765, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 134, TO_TIMESTAMP('2022-08-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (766, TO_TIMESTAMP('2022-08-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(766, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(766, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(766, 3, 3);
INSERT INTO prescribed_treatments VALUES(766, 2, 1);
INSERT INTO payment_info VALUES (766, 10000, 80000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최하준', '660118-1111111', '서울특별시 금천구', '02-614-6237', '010-8038-8476', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 386, TO_TIMESTAMP('2022-08-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (767, TO_TIMESTAMP('2022-08-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(767, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(767, 6, 1);
INSERT INTO prescribed_treatments VALUES(767, 10, 2);
INSERT INTO payment_info VALUES (767, 10000, 510000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 333, TO_TIMESTAMP('2022-08-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (768, TO_TIMESTAMP('2022-08-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(768, 600, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(768, 5, 3);
INSERT INTO prescribed_treatments VALUES(768, 4, 3);
INSERT INTO payment_info VALUES (768, 5000, 600000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이주원', '670621-1111111', '서울특별시 양천구', '02-159-3157', '010-5549-8041', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 387, TO_TIMESTAMP('2022-08-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (769, TO_TIMESTAMP('2022-08-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(769, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(769, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(769, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(769, 6, 1);
INSERT INTO payment_info VALUES (769, 5000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 40, TO_TIMESTAMP('2022-08-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (770, TO_TIMESTAMP('2022-08-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(770, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (770, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 44, TO_TIMESTAMP('2022-08-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (771, TO_TIMESTAMP('2022-08-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(771, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(771, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(771, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (771, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이수호', '250826-2222222', '서울특별시 서대문구', '02-870-8293', '010-7911-4603', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 388, TO_TIMESTAMP('2022-08-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (772, TO_TIMESTAMP('2022-08-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (772, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 118, TO_TIMESTAMP('2022-08-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (773, TO_TIMESTAMP('2022-08-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(773, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(773, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(773, 2, 3);
INSERT INTO payment_info VALUES (773, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박우진', '451021-1111111', '서울특별시 강동구', '02-388-3640', '010-3997-7899', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 389, TO_TIMESTAMP('2022-08-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (774, TO_TIMESTAMP('2022-08-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(774, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(774, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(774, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (774, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 304, TO_TIMESTAMP('2022-08-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (775, TO_TIMESTAMP('2022-08-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (775, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-08-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (776, TO_TIMESTAMP('2022-08-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(776, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (776, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강유나', '951022-2222222', '서울특별시 성북구', '02-814-3119', '010-7254-5008', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 390, TO_TIMESTAMP('2022-08-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (777, TO_TIMESTAMP('2022-08-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(777, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (777, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서윤', '050823-4444444', '서울특별시 영등포구', '02-664-5309', '010-1317-8831', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 391, TO_TIMESTAMP('2022-08-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (778, TO_TIMESTAMP('2022-08-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(778, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(778, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(778, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (778, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 125, TO_TIMESTAMP('2022-08-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (779, TO_TIMESTAMP('2022-08-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(779, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(779, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(779, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (779, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지유', '400803-2222222', '서울특별시 종로구', '02-473-4710', '010-8400-4411', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 392, TO_TIMESTAMP('2022-08-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (780, TO_TIMESTAMP('2022-08-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(780, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(780, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(780, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (780, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 185, TO_TIMESTAMP('2022-08-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (781, TO_TIMESTAMP('2022-08-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(781, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(781, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (781, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 125, TO_TIMESTAMP('2022-08-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (782, TO_TIMESTAMP('2022-08-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(782, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(782, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(782, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (782, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지민', '541013-1111111', '서울특별시 용산구', '02-963-6936', '010-4803-1589', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 393, TO_TIMESTAMP('2022-08-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (783, TO_TIMESTAMP('2022-08-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(783, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(783, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(783, 9, 1);
INSERT INTO payment_info VALUES (783, 5000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장연우', '751118-2222222', '서울특별시 광진구', '02-137-1977', '010-7061-6522', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 394, TO_TIMESTAMP('2022-08-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (784, TO_TIMESTAMP('2022-08-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (784, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 87, TO_TIMESTAMP('2022-08-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (785, TO_TIMESTAMP('2022-08-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(785, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(785, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(785, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (785, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박다인', '541128-2222222', '서울특별시 강동구', '02-179-8958', '010-1194-3519', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 395, TO_TIMESTAMP('2022-08-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (786, TO_TIMESTAMP('2022-08-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(786, 700, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(786, 3, 2);
INSERT INTO prescribed_treatments VALUES(786, 9, 3);
INSERT INTO payment_info VALUES (786, 5000, 320000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 177, TO_TIMESTAMP('2022-08-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (787, TO_TIMESTAMP('2022-08-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (787, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이유주', '080228-3333333', '서울특별시 광진구', '02-528-1772', '010-7675-5551', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 396, TO_TIMESTAMP('2022-08-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (788, TO_TIMESTAMP('2022-08-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(788, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(788, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(788, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (788, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시우', '650806-2222222', '서울특별시 종로구', '02-627-5440', '010-3316-9442', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 397, TO_TIMESTAMP('2022-08-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (789, TO_TIMESTAMP('2022-08-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (789, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 1, TO_TIMESTAMP('2022-08-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (790, TO_TIMESTAMP('2022-08-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (790, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 223, TO_TIMESTAMP('2022-08-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (791, TO_TIMESTAMP('2022-08-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(791, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(791, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (791, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예은', '221219-2222222', '서울특별시 은평구', '02-532-9127', '010-7291-3728', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 398, TO_TIMESTAMP('2022-08-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (792, TO_TIMESTAMP('2022-08-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(792, 6, 2);
INSERT INTO prescribed_treatments VALUES(792, 8, 3);
INSERT INTO payment_info VALUES (792, 5000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김도현', '980215-1111111', '서울특별시 노원구', '02-683-2205', '010-5444-5692', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 399, TO_TIMESTAMP('2022-08-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (793, TO_TIMESTAMP('2022-08-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(793, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(793, 700, 1, 2, 5);
INSERT INTO payment_info VALUES (793, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 231, TO_TIMESTAMP('2022-08-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (794, TO_TIMESTAMP('2022-08-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(794, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(794, 7, 1);
INSERT INTO prescribed_treatments VALUES(794, 4, 2);
INSERT INTO payment_info VALUES (794, 3000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 113, TO_TIMESTAMP('2022-08-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (795, TO_TIMESTAMP('2022-08-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (795, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 29, TO_TIMESTAMP('2022-08-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (796, TO_TIMESTAMP('2022-08-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(796, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (796, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 302, TO_TIMESTAMP('2022-08-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (797, TO_TIMESTAMP('2022-08-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(797, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(797, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (797, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 178, TO_TIMESTAMP('2022-08-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (798, TO_TIMESTAMP('2022-08-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(798, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(798, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(798, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (798, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조하은', '320208-2222222', '서울특별시 강동구', '02-254-1408', '010-1935-3369', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 400, TO_TIMESTAMP('2022-08-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (799, TO_TIMESTAMP('2022-08-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(799, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (799, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예진', '890506-1111111', '서울특별시 강동구', '02-852-6911', '010-1476-9699', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 401, TO_TIMESTAMP('2022-08-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (800, TO_TIMESTAMP('2022-08-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (800, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 2, TO_TIMESTAMP('2022-08-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (801, TO_TIMESTAMP('2022-08-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(801, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(801, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(801, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(801, 8, 3);
INSERT INTO prescribed_treatments VALUES(801, 1, 2);
INSERT INTO payment_info VALUES (801, 3000, 350000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 263, TO_TIMESTAMP('2022-08-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (802, TO_TIMESTAMP('2022-08-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (802, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정하윤', '360608-1111111', '서울특별시 동작구', '02-569-4226', '010-5230-9473', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 402, TO_TIMESTAMP('2022-08-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (803, TO_TIMESTAMP('2022-08-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(803, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (803, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 319, TO_TIMESTAMP('2022-08-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (804, TO_TIMESTAMP('2022-08-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (804, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 265, TO_TIMESTAMP('2022-08-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (805, TO_TIMESTAMP('2022-08-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(805, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(805, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (805, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서율', '470201-1111111', '서울특별시 종로구', '02-352-8715', '010-5193-9985', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 403, TO_TIMESTAMP('2022-08-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (806, TO_TIMESTAMP('2022-08-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(806, 5, 3);
INSERT INTO payment_info VALUES (806, 5000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 226, TO_TIMESTAMP('2022-08-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (807, TO_TIMESTAMP('2022-08-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(807, 800, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(807, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(807, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (807, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 208, TO_TIMESTAMP('2022-08-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (808, TO_TIMESTAMP('2022-08-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(808, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(808, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(808, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (808, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍승민', '110817-3333333', '서울특별시 성동구', '02-160-9738', '010-2760-8850', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 404, TO_TIMESTAMP('2022-09-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (809, TO_TIMESTAMP('2022-09-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(809, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(809, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(809, 600, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(809, 3, 2);
INSERT INTO payment_info VALUES (809, 10000, 20000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 377, TO_TIMESTAMP('2022-09-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (810, TO_TIMESTAMP('2022-09-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(810, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(810, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(810, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (810, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이정우', '951024-1111111', '서울특별시 금천구', '02-704-9789', '010-7402-7285', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 405, TO_TIMESTAMP('2022-09-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (811, TO_TIMESTAMP('2022-09-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(811, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(811, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(811, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(811, 4, 2);
INSERT INTO prescribed_treatments VALUES(811, 2, 1);
INSERT INTO payment_info VALUES (811, 10000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허주원', '700615-2222222', '서울특별시 강남구', '02-344-6724', '010-8081-4855', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 406, TO_TIMESTAMP('2022-09-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (812, TO_TIMESTAMP('2022-09-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(812, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(812, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(812, 7, 1);
INSERT INTO payment_info VALUES (812, 30000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 193, TO_TIMESTAMP('2022-09-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (813, TO_TIMESTAMP('2022-09-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(813, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(813, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(813, 9, 3);
INSERT INTO payment_info VALUES (813, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 308, TO_TIMESTAMP('2022-09-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (814, TO_TIMESTAMP('2022-09-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(814, 1000, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(814, 7, 2);
INSERT INTO payment_info VALUES (814, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허채원', '001105-4444444', '서울특별시 양천구', '02-843-1976', '010-9863-5062', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 407, TO_TIMESTAMP('2022-09-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (815, TO_TIMESTAMP('2022-09-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (815, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 74, TO_TIMESTAMP('2022-09-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (816, TO_TIMESTAMP('2022-09-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(816, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (816, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장예나', '671109-1111111', '서울특별시 양천구', '02-277-9540', '010-1188-9306', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 408, TO_TIMESTAMP('2022-09-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (817, TO_TIMESTAMP('2022-09-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(817, 10, 2);
INSERT INTO payment_info VALUES (817, 10000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 333, TO_TIMESTAMP('2022-09-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (818, TO_TIMESTAMP('2022-09-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(818, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(818, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(818, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(818, 4, 2);
INSERT INTO payment_info VALUES (818, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 385, TO_TIMESTAMP('2022-09-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (819, TO_TIMESTAMP('2022-09-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(819, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (819, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조현우', '820603-1111111', '서울특별시 금천구', '02-419-7824', '010-2087-6294', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 409, TO_TIMESTAMP('2022-09-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (820, TO_TIMESTAMP('2022-09-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(820, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(820, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(820, 7, 2);
INSERT INTO prescribed_treatments VALUES(820, 3, 2);
INSERT INTO payment_info VALUES (820, 10000, 320000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 198, TO_TIMESTAMP('2022-09-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (821, TO_TIMESTAMP('2022-09-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(821, 7, 2);
INSERT INTO payment_info VALUES (821, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예준', '981214-2222222', '서울특별시 마포구', '02-783-7233', '010-3055-3289', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 410, TO_TIMESTAMP('2022-09-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (822, TO_TIMESTAMP('2022-09-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(822, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (822, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예린', '921104-1111111', '서울특별시 종로구', '02-467-3536', '010-4759-1225', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 411, TO_TIMESTAMP('2022-09-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (823, TO_TIMESTAMP('2022-09-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(823, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (823, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 341, TO_TIMESTAMP('2022-09-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (824, TO_TIMESTAMP('2022-09-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (824, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장지율', '410612-1111111', '서울특별시 동작구', '02-301-3026', '010-6593-4205', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 412, TO_TIMESTAMP('2022-09-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (825, TO_TIMESTAMP('2022-09-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(825, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(825, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(825, 600, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(825, 3, 2);
INSERT INTO payment_info VALUES (825, 5000, 20000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 323, TO_TIMESTAMP('2022-09-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (826, TO_TIMESTAMP('2022-09-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(826, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(826, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (826, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지호', '900106-1111111', '서울특별시 도봉구', '02-352-8370', '010-4527-1835', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 413, TO_TIMESTAMP('2022-09-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (827, TO_TIMESTAMP('2022-09-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(827, 1, 1);
INSERT INTO prescribed_treatments VALUES(827, 7, 1);
INSERT INTO payment_info VALUES (827, 10000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 294, TO_TIMESTAMP('2022-09-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (828, TO_TIMESTAMP('2022-09-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (828, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서율', '070801-4444444', '서울특별시 종로구', '02-204-1800', '010-3696-8002', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 414, TO_TIMESTAMP('2022-09-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (829, TO_TIMESTAMP('2022-09-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(829, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(829, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(829, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (829, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 317, TO_TIMESTAMP('2022-09-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (830, TO_TIMESTAMP('2022-09-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(830, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(830, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(830, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (830, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시후', '590319-2222222', '서울특별시 동대문구', '02-645-2192', '010-7648-8955', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 415, TO_TIMESTAMP('2022-09-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (831, TO_TIMESTAMP('2022-09-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(831, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(831, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(831, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (831, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 386, TO_TIMESTAMP('2022-09-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (832, TO_TIMESTAMP('2022-09-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(832, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(832, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(832, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (832, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 345, TO_TIMESTAMP('2022-09-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (833, TO_TIMESTAMP('2022-09-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(833, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (833, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조하준', '200527-1111111', '서울특별시 성동구', '02-134-6608', '010-6693-1186', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 416, TO_TIMESTAMP('2022-09-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (834, TO_TIMESTAMP('2022-09-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(834, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(834, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(834, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (834, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 179, TO_TIMESTAMP('2022-09-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (835, TO_TIMESTAMP('2022-09-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(835, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(835, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (835, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장정우', '510525-1111111', '서울특별시 도봉구', '02-263-5983', '010-4431-3996', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 417, TO_TIMESTAMP('2022-09-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (836, TO_TIMESTAMP('2022-09-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (836, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박서율', '600120-1111111', '서울특별시 성북구', '02-800-3163', '010-5961-6676', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 418, TO_TIMESTAMP('2022-09-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (837, TO_TIMESTAMP('2022-09-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (837, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 353, TO_TIMESTAMP('2022-09-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (838, TO_TIMESTAMP('2022-09-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(838, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (838, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허시연', '340825-1111111', '서울특별시 광진구', '02-976-3362', '010-1250-3697', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 419, TO_TIMESTAMP('2022-09-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (839, TO_TIMESTAMP('2022-09-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (839, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정도현', '170726-4444444', '서울특별시 금천구', '02-362-7120', '010-9741-4482', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 420, TO_TIMESTAMP('2022-09-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (840, TO_TIMESTAMP('2022-09-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(840, 400, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(840, 7, 1);
INSERT INTO payment_info VALUES (840, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최가은', '091220-3333333', '서울특별시 서대문구', '02-681-5886', '010-8762-2529', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 421, TO_TIMESTAMP('2022-09-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (841, TO_TIMESTAMP('2022-09-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(841, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (841, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 142, TO_TIMESTAMP('2022-09-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (842, TO_TIMESTAMP('2022-09-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(842, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(842, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(842, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(842, 8, 2);
INSERT INTO prescribed_treatments VALUES(842, 2, 3);
INSERT INTO payment_info VALUES (842, 15000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조선우', '990612-2222222', '서울특별시 성북구', '02-844-8823', '010-4271-4025', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 422, TO_TIMESTAMP('2022-09-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (843, TO_TIMESTAMP('2022-09-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(843, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(843, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (843, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 259, TO_TIMESTAMP('2022-09-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (844, TO_TIMESTAMP('2022-09-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(844, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(844, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (844, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이준우', '750701-1111111', '서울특별시 영등포구', '02-733-3745', '010-6937-5086', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 423, TO_TIMESTAMP('2022-09-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (845, TO_TIMESTAMP('2022-09-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(845, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(845, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (845, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 112, TO_TIMESTAMP('2022-09-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (846, TO_TIMESTAMP('2022-09-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (846, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 118, TO_TIMESTAMP('2022-09-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (847, TO_TIMESTAMP('2022-09-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(847, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(847, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(847, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (847, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최지아', '410514-2222222', '서울특별시 중구', '02-439-8087', '010-1133-1362', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 424, TO_TIMESTAMP('2022-09-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (848, TO_TIMESTAMP('2022-09-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(848, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(848, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(848, 500, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(848, 2, 3);
INSERT INTO prescribed_treatments VALUES(848, 6, 2);
INSERT INTO payment_info VALUES (848, 3000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장채원', '780412-2222222', '서울특별시 금천구', '02-615-8072', '010-7304-6536', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 425, TO_TIMESTAMP('2022-09-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (849, TO_TIMESTAMP('2022-09-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (849, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 275, TO_TIMESTAMP('2022-09-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (850, TO_TIMESTAMP('2022-09-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(850, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(850, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(850, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (850, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시연', '251007-1111111', '서울특별시 강북구', '02-626-1665', '010-9597-7638', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 426, TO_TIMESTAMP('2022-09-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (851, TO_TIMESTAMP('2022-09-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(851, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(851, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(851, 500, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(851, 7, 2);
INSERT INTO payment_info VALUES (851, 3000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 174, TO_TIMESTAMP('2022-09-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (852, TO_TIMESTAMP('2022-09-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(852, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(852, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (852, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임유준', '610616-1111111', '서울특별시 광진구', '02-545-4675', '010-5087-2424', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 427, TO_TIMESTAMP('2022-09-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (853, TO_TIMESTAMP('2022-09-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(853, 200, 1, 3, 3);
INSERT INTO payment_info VALUES (853, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 259, TO_TIMESTAMP('2022-09-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (854, TO_TIMESTAMP('2022-09-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(854, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(854, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(854, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (854, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 309, TO_TIMESTAMP('2022-09-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (855, TO_TIMESTAMP('2022-09-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (855, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 156, TO_TIMESTAMP('2022-09-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (856, TO_TIMESTAMP('2022-09-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(856, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(856, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(856, 700, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(856, 7, 3);
INSERT INTO prescribed_treatments VALUES(856, 8, 3);
INSERT INTO payment_info VALUES (856, 10000, 600000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강채원', '650615-1111111', '서울특별시 양천구', '02-763-6695', '010-4521-4874', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 428, TO_TIMESTAMP('2022-09-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (857, TO_TIMESTAMP('2022-09-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(857, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(857, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(857, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(857, 10, 3);
INSERT INTO prescribed_treatments VALUES(857, 3, 1);
INSERT INTO payment_info VALUES (857, 10000, 700000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정윤서', '531209-2222222', '서울특별시 동대문구', '02-734-7737', '010-6960-6048', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 429, TO_TIMESTAMP('2022-09-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (858, TO_TIMESTAMP('2022-09-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(858, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (858, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 277, TO_TIMESTAMP('2022-09-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (859, TO_TIMESTAMP('2022-09-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(859, 7, 2);
INSERT INTO prescribed_treatments VALUES(859, 1, 2);
INSERT INTO payment_info VALUES (859, 15000, 500000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 281, TO_TIMESTAMP('2022-09-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (860, TO_TIMESTAMP('2022-09-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(860, 4, 1);
INSERT INTO prescribed_treatments VALUES(860, 2, 3);
INSERT INTO payment_info VALUES (860, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최다온', '960105-1111111', '서울특별시 양천구', '02-794-8626', '010-1737-1676', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 430, TO_TIMESTAMP('2022-09-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (861, TO_TIMESTAMP('2022-09-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(861, 2, 2);
INSERT INTO prescribed_treatments VALUES(861, 8, 3);
INSERT INTO payment_info VALUES (861, 10000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 76, TO_TIMESTAMP('2022-09-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (862, TO_TIMESTAMP('2022-09-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(862, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(862, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(862, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(862, 10, 2);
INSERT INTO payment_info VALUES (862, 10000, 460000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최예원', '790124-2222222', '서울특별시 서대문구', '02-407-6759', '010-9199-8111', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 431, TO_TIMESTAMP('2022-09-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (863, TO_TIMESTAMP('2022-09-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(863, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(863, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(863, 2, 1);
INSERT INTO payment_info VALUES (863, 10000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍진우', '420101-2222222', '서울특별시 강남구', '02-233-5625', '010-9123-8834', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 432, TO_TIMESTAMP('2022-09-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (864, TO_TIMESTAMP('2022-09-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(864, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(864, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (864, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 100, TO_TIMESTAMP('2022-09-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (865, TO_TIMESTAMP('2022-09-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (865, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강시우', '600424-2222222', '서울특별시 동작구', '02-905-3616', '010-6770-4155', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 433, TO_TIMESTAMP('2022-09-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (866, TO_TIMESTAMP('2022-09-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(866, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(866, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (866, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 325, TO_TIMESTAMP('2022-09-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (867, TO_TIMESTAMP('2022-09-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(867, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (867, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박승현', '181103-3333333', '서울특별시 성동구', '02-459-4239', '010-5304-8749', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 434, TO_TIMESTAMP('2022-09-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (868, TO_TIMESTAMP('2022-09-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (868, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 107, TO_TIMESTAMP('2022-09-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (869, TO_TIMESTAMP('2022-09-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_treatments VALUES(869, 10, 2);
INSERT INTO payment_info VALUES (869, 5000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 216, TO_TIMESTAMP('2022-09-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (870, TO_TIMESTAMP('2022-09-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(870, 7, 2);
INSERT INTO payment_info VALUES (870, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장채은', '030704-3333333', '서울특별시 강북구', '02-180-4045', '010-9817-8588', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 435, TO_TIMESTAMP('2022-09-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (871, TO_TIMESTAMP('2022-09-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(871, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (871, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조승우', '101110-3333333', '서울특별시 광진구', '02-615-1091', '010-8857-3498', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 436, TO_TIMESTAMP('2022-09-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (872, TO_TIMESTAMP('2022-09-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(872, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(872, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(872, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(872, 8, 3);
INSERT INTO payment_info VALUES (872, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 97, TO_TIMESTAMP('2022-09-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (873, TO_TIMESTAMP('2022-09-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(873, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(873, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (873, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정다온', '890519-1111111', '서울특별시 서대문구', '02-449-2747', '010-2775-3602', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 437, TO_TIMESTAMP('2022-09-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (874, TO_TIMESTAMP('2022-09-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(874, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(874, 7, 1);
INSERT INTO payment_info VALUES (874, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 109, TO_TIMESTAMP('2022-09-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (875, TO_TIMESTAMP('2022-09-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(875, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (875, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 316, TO_TIMESTAMP('2022-09-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (876, TO_TIMESTAMP('2022-09-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(876, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(876, 100, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(876, 8, 2);
INSERT INTO prescribed_treatments VALUES(876, 5, 2);
INSERT INTO payment_info VALUES (876, 15000, 400000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조하준', '300923-2222222', '서울특별시 은평구', '02-447-1206', '010-6030-4717', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 438, TO_TIMESTAMP('2022-09-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (877, TO_TIMESTAMP('2022-09-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(877, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(877, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(877, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (877, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임현우', '830521-1111111', '서울특별시 강남구', '02-869-8045', '010-4627-9222', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 439, TO_TIMESTAMP('2022-09-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (878, TO_TIMESTAMP('2022-09-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(878, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(878, 1, 2);
INSERT INTO prescribed_treatments VALUES(878, 3, 1);
INSERT INTO payment_info VALUES (878, 3000, 210000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 431, TO_TIMESTAMP('2022-09-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (879, TO_TIMESTAMP('2022-09-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (879, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김주원', '270108-1111111', '서울특별시 마포구', '02-594-5614', '010-8430-8924', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 440, TO_TIMESTAMP('2022-09-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (880, TO_TIMESTAMP('2022-09-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(880, 600, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(880, 5, 1);
INSERT INTO prescribed_treatments VALUES(880, 8, 2);
INSERT INTO payment_info VALUES (880, 10000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지호', '260815-1111111', '서울특별시 금천구', '02-332-4945', '010-4358-7697', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 441, TO_TIMESTAMP('2022-09-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (881, TO_TIMESTAMP('2022-09-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(881, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(881, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(881, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (881, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 341, TO_TIMESTAMP('2022-09-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (882, TO_TIMESTAMP('2022-09-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(882, 200, 1, 3, 5);
INSERT INTO payment_info VALUES (882, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이다은', '821122-2222222', '서울특별시 도봉구', '02-293-5790', '010-7571-5203', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 442, TO_TIMESTAMP('2022-09-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (883, TO_TIMESTAMP('2022-09-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (883, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장민준', '291011-2222222', '서울특별시 동대문구', '02-684-7739', '010-1902-8593', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 443, TO_TIMESTAMP('2022-09-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (884, TO_TIMESTAMP('2022-09-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(884, 3, 3);
INSERT INTO prescribed_treatments VALUES(884, 7, 2);
INSERT INTO payment_info VALUES (884, 5000, 330000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 400, TO_TIMESTAMP('2022-09-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (885, TO_TIMESTAMP('2022-09-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(885, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (885, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조지유', '490207-2222222', '서울특별시 양천구', '02-443-5127', '010-4254-2457', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 444, TO_TIMESTAMP('2022-09-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (886, TO_TIMESTAMP('2022-09-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(886, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(886, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(886, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(886, 3, 3);
INSERT INTO prescribed_treatments VALUES(886, 10, 3);
INSERT INTO payment_info VALUES (886, 10000, 720000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍연우', '210623-3333333', '서울특별시 영등포구', '02-961-5204', '010-9814-2146', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 445, TO_TIMESTAMP('2022-09-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (887, TO_TIMESTAMP('2022-09-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(887, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (887, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 16, TO_TIMESTAMP('2022-09-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (888, TO_TIMESTAMP('2022-09-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(888, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(888, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(888, 9, 1);
INSERT INTO payment_info VALUES (888, 5000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최시은', '510314-2222222', '서울특별시 동작구', '02-877-1678', '010-2361-4410', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 446, TO_TIMESTAMP('2022-09-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (889, TO_TIMESTAMP('2022-09-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(889, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(889, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(889, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (889, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박수아', '590619-1111111', '서울특별시 관악구', '02-282-1526', '010-4299-5271', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 447, TO_TIMESTAMP('2022-09-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (890, TO_TIMESTAMP('2022-09-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(890, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (890, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박도현', '000711-4444444', '서울특별시 영등포구', '02-906-3160', '010-8455-1586', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 448, TO_TIMESTAMP('2022-09-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (891, TO_TIMESTAMP('2022-09-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(891, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(891, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (891, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 280, TO_TIMESTAMP('2022-09-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (892, TO_TIMESTAMP('2022-09-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(892, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(892, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (892, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장가은', '180106-3333333', '서울특별시 관악구', '02-790-1006', '010-9043-5877', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 449, TO_TIMESTAMP('2022-09-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (893, TO_TIMESTAMP('2022-09-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(893, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(893, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(893, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (893, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 72, TO_TIMESTAMP('2022-09-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (894, TO_TIMESTAMP('2022-09-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(894, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(894, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (894, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 307, TO_TIMESTAMP('2022-09-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (895, TO_TIMESTAMP('2022-09-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(895, 5, 1);
INSERT INTO payment_info VALUES (895, 3000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조윤우', '730814-2222222', '서울특별시 중랑구', '02-704-2970', '010-2251-4822', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 450, TO_TIMESTAMP('2022-09-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (896, TO_TIMESTAMP('2022-09-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(896, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (896, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임민성', '520910-2222222', '서울특별시 동대문구', '02-335-9973', '010-5707-2715', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 451, TO_TIMESTAMP('2022-09-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (897, TO_TIMESTAMP('2022-09-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(897, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (897, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 300, TO_TIMESTAMP('2022-09-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (898, TO_TIMESTAMP('2022-09-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(898, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(898, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(898, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(898, 2, 1);
INSERT INTO payment_info VALUES (898, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조다인', '731010-2222222', '서울특별시 동작구', '02-602-6332', '010-2846-8967', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 452, TO_TIMESTAMP('2022-09-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (899, TO_TIMESTAMP('2022-09-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(899, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(899, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(899, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(899, 3, 2);
INSERT INTO prescribed_treatments VALUES(899, 1, 2);
INSERT INTO payment_info VALUES (899, 10000, 220000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 115, TO_TIMESTAMP('2022-09-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (900, TO_TIMESTAMP('2022-09-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(900, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (900, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임현준', '270427-1111111', '서울특별시 강서구', '02-857-3478', '010-8109-6969', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 453, TO_TIMESTAMP('2022-09-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (901, TO_TIMESTAMP('2022-09-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(901, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(901, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(901, 10, 3);
INSERT INTO payment_info VALUES (901, 30000, 690000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 38, TO_TIMESTAMP('2022-09-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (902, TO_TIMESTAMP('2022-09-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(902, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (902, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 289, TO_TIMESTAMP('2022-09-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (903, TO_TIMESTAMP('2022-09-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(903, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(903, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(903, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (903, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장소율', '211106-3333333', '서울특별시 서대문구', '02-532-4442', '010-7066-2389', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 454, TO_TIMESTAMP('2022-10-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (904, TO_TIMESTAMP('2022-10-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(904, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(904, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (904, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 82, TO_TIMESTAMP('2022-10-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (905, TO_TIMESTAMP('2022-10-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (905, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김예은', '060510-3333333', '서울특별시 성동구', '02-365-9338', '010-3728-8198', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 455, TO_TIMESTAMP('2022-10-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (906, TO_TIMESTAMP('2022-10-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(906, 4, 3);
INSERT INTO payment_info VALUES (906, 3000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장정우', '321027-2222222', '서울특별시 관악구', '02-359-8357', '010-4789-8788', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 456, TO_TIMESTAMP('2022-10-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (907, TO_TIMESTAMP('2022-10-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(907, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(907, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(907, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(907, 9, 3);
INSERT INTO payment_info VALUES (907, 5000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 31, TO_TIMESTAMP('2022-10-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (908, TO_TIMESTAMP('2022-10-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(908, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(908, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(908, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (908, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 5, TO_TIMESTAMP('2022-10-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (909, TO_TIMESTAMP('2022-10-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(909, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(909, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (909, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조예나', '321101-2222222', '서울특별시 관악구', '02-799-8118', '010-1601-2283', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 457, TO_TIMESTAMP('2022-10-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (910, TO_TIMESTAMP('2022-10-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(910, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(910, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(910, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (910, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 235, TO_TIMESTAMP('2022-10-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (911, TO_TIMESTAMP('2022-10-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(911, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(911, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(911, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (911, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허수아', '160305-3333333', '서울특별시 종로구', '02-543-1893', '010-7972-4062', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 458, TO_TIMESTAMP('2022-10-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (912, TO_TIMESTAMP('2022-10-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(912, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(912, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(912, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (912, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이수연', '980814-1111111', '서울특별시 강서구', '02-929-6547', '010-9743-8500', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 459, TO_TIMESTAMP('2022-10-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (913, TO_TIMESTAMP('2022-10-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(913, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(913, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (913, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 366, TO_TIMESTAMP('2022-10-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (914, TO_TIMESTAMP('2022-10-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(914, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (914, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허시윤', '270516-2222222', '서울특별시 노원구', '02-737-3760', '010-6711-4455', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 460, TO_TIMESTAMP('2022-10-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (915, TO_TIMESTAMP('2022-10-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(915, 100, 1, 1, 7);
INSERT INTO payment_info VALUES (915, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 226, TO_TIMESTAMP('2022-10-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (916, TO_TIMESTAMP('2022-10-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(916, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(916, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(916, 3, 2);
INSERT INTO prescribed_treatments VALUES(916, 5, 2);
INSERT INTO payment_info VALUES (916, 5000, 320000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 393, TO_TIMESTAMP('2022-10-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (917, TO_TIMESTAMP('2022-10-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(917, 100, 1, 3, 5);
INSERT INTO payment_info VALUES (917, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 193, TO_TIMESTAMP('2022-10-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (918, TO_TIMESTAMP('2022-10-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(918, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (918, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 318, TO_TIMESTAMP('2022-10-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (919, TO_TIMESTAMP('2022-10-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (919, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 389, TO_TIMESTAMP('2022-10-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (920, TO_TIMESTAMP('2022-10-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(920, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(920, 500, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(920, 2, 3);
INSERT INTO prescribed_treatments VALUES(920, 3, 3);
INSERT INTO payment_info VALUES (920, 5000, 180000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서율', '040921-4444444', '서울특별시 용산구', '02-541-9713', '010-8021-2345', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 461, TO_TIMESTAMP('2022-10-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (921, TO_TIMESTAMP('2022-10-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(921, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(921, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(921, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(921, 4, 3);
INSERT INTO prescribed_treatments VALUES(921, 5, 2);
INSERT INTO payment_info VALUES (921, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허아인', '470407-2222222', '서울특별시 서초구', '02-229-4229', '010-8413-1715', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 462, TO_TIMESTAMP('2022-10-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (922, TO_TIMESTAMP('2022-10-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (922, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 361, TO_TIMESTAMP('2022-10-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (923, TO_TIMESTAMP('2022-10-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(923, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(923, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(923, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(923, 6, 3);
INSERT INTO prescribed_treatments VALUES(923, 8, 2);
INSERT INTO payment_info VALUES (923, 10000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장서우', '981224-1111111', '서울특별시 서초구', '02-738-2749', '010-9735-5664', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 463, TO_TIMESTAMP('2022-10-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (924, TO_TIMESTAMP('2022-10-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(924, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(924, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(924, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(924, 2, 1);
INSERT INTO prescribed_treatments VALUES(924, 9, 1);
INSERT INTO payment_info VALUES (924, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 330, TO_TIMESTAMP('2022-10-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (925, TO_TIMESTAMP('2022-10-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(925, 1, 1);
INSERT INTO payment_info VALUES (925, 10000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 457, TO_TIMESTAMP('2022-10-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (926, TO_TIMESTAMP('2022-10-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (926, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박예은', '660826-2222222', '서울특별시 동작구', '02-598-9975', '010-9323-6793', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 464, TO_TIMESTAMP('2022-10-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (927, TO_TIMESTAMP('2022-10-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(927, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(927, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (927, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2022-10-08 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (928, TO_TIMESTAMP('2022-10-08 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(928, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(928, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(928, 400, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(928, 5, 1);
INSERT INTO payment_info VALUES (928, 3000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유준', '210620-4444444', '서울특별시 동대문구', '02-375-2924', '010-8858-4510', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 465, TO_TIMESTAMP('2022-10-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (929, TO_TIMESTAMP('2022-10-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(929, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(929, 800, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(929, 7, 2);
INSERT INTO payment_info VALUES (929, 10000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예나', '730219-2222222', '서울특별시 종로구', '02-325-6820', '010-9542-4379', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 466, TO_TIMESTAMP('2022-10-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (930, TO_TIMESTAMP('2022-10-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(930, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (930, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-10-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (931, TO_TIMESTAMP('2022-10-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(931, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(931, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (931, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 258, TO_TIMESTAMP('2022-10-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (932, TO_TIMESTAMP('2022-10-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(932, 6, 2);
INSERT INTO payment_info VALUES (932, 30000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이서율', '440822-1111111', '서울특별시 중구', '02-146-5045', '010-5534-4382', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 467, TO_TIMESTAMP('2022-10-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (933, TO_TIMESTAMP('2022-10-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(933, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (933, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유준', '230909-1111111', '서울특별시 서대문구', '02-701-4119', '010-6649-7630', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 468, TO_TIMESTAMP('2022-10-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (934, TO_TIMESTAMP('2022-10-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(934, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(934, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (934, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최아린', '770811-1111111', '서울특별시 종로구', '02-604-3095', '010-6584-8350', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 469, TO_TIMESTAMP('2022-10-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (935, TO_TIMESTAMP('2022-10-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(935, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (935, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 80, TO_TIMESTAMP('2022-10-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (936, TO_TIMESTAMP('2022-10-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(936, 600, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(936, 6, 2);
INSERT INTO prescribed_treatments VALUES(936, 8, 2);
INSERT INTO payment_info VALUES (936, 10000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허은서', '440409-2222222', '서울특별시 구로구', '02-702-4570', '010-5864-1302', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 470, TO_TIMESTAMP('2022-10-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (937, TO_TIMESTAMP('2022-10-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(937, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (937, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 445, TO_TIMESTAMP('2022-10-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (938, TO_TIMESTAMP('2022-10-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(938, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(938, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(938, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (938, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍아인', '380408-1111111', '서울특별시 은평구', '02-786-4568', '010-9375-1140', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 471, TO_TIMESTAMP('2022-10-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (939, TO_TIMESTAMP('2022-10-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(939, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(939, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (939, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 111, TO_TIMESTAMP('2022-10-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (940, TO_TIMESTAMP('2022-10-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (940, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지호', '570419-1111111', '서울특별시 광진구', '02-697-3401', '010-5595-9493', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 472, TO_TIMESTAMP('2022-10-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (941, TO_TIMESTAMP('2022-10-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(941, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(941, 600, 1, 1, 7);
INSERT INTO payment_info VALUES (941, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 306, TO_TIMESTAMP('2022-10-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (942, TO_TIMESTAMP('2022-10-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(942, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(942, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (942, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조지윤', '870319-1111111', '서울특별시 강서구', '02-362-2128', '010-7277-6469', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 473, TO_TIMESTAMP('2022-10-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (943, TO_TIMESTAMP('2022-10-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(943, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (943, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 177, TO_TIMESTAMP('2022-10-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (944, TO_TIMESTAMP('2022-10-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (944, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 313, TO_TIMESTAMP('2022-10-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (945, TO_TIMESTAMP('2022-10-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (945, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 218, TO_TIMESTAMP('2022-10-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (946, TO_TIMESTAMP('2022-10-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(946, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (946, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이민지', '570308-2222222', '서울특별시 광진구', '02-419-2826', '010-5515-2064', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 474, TO_TIMESTAMP('2022-10-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (947, TO_TIMESTAMP('2022-10-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(947, 7, 1);
INSERT INTO payment_info VALUES (947, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 277, TO_TIMESTAMP('2022-10-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (948, TO_TIMESTAMP('2022-10-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(948, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(948, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(948, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (948, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍지윤', '390512-2222222', '서울특별시 중구', '02-983-6683', '010-3583-7207', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 475, TO_TIMESTAMP('2022-10-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (949, TO_TIMESTAMP('2022-10-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(949, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(949, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(949, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (949, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 75, TO_TIMESTAMP('2022-10-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (950, TO_TIMESTAMP('2022-10-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(950, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (950, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강서진', '640824-2222222', '서울특별시 강동구', '02-290-1749', '010-6251-7161', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 476, TO_TIMESTAMP('2022-10-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (951, TO_TIMESTAMP('2022-10-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(951, 4, 1);
INSERT INTO payment_info VALUES (951, 5000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 115, TO_TIMESTAMP('2022-10-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (952, TO_TIMESTAMP('2022-10-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(952, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(952, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(952, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (952, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임현서', '861210-2222222', '서울특별시 강북구', '02-251-9160', '010-9680-7275', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 477, TO_TIMESTAMP('2022-10-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (953, TO_TIMESTAMP('2022-10-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(953, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(953, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(953, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(953, 2, 3);
INSERT INTO prescribed_treatments VALUES(953, 4, 2);
INSERT INTO payment_info VALUES (953, 5000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 69, TO_TIMESTAMP('2022-10-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (954, TO_TIMESTAMP('2022-10-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(954, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(954, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (954, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지안', '181227-4444444', '서울특별시 용산구', '02-659-9579', '010-2337-1676', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 478, TO_TIMESTAMP('2022-10-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (955, TO_TIMESTAMP('2022-10-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(955, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(955, 100, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(955, 2, 2);
INSERT INTO prescribed_treatments VALUES(955, 3, 1);
INSERT INTO payment_info VALUES (955, 3000, 110000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조채원', '031012-4444444', '서울특별시 동작구', '02-235-2020', '010-3749-8836', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 479, TO_TIMESTAMP('2022-10-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (956, TO_TIMESTAMP('2022-10-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(956, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(956, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(956, 500, 1, 2, 3);
INSERT INTO payment_info VALUES (956, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허아린', '040804-4444444', '서울특별시 강서구', '02-115-7553', '010-9377-5134', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 480, TO_TIMESTAMP('2022-10-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (957, TO_TIMESTAMP('2022-10-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(957, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(957, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (957, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 128, TO_TIMESTAMP('2022-10-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (958, TO_TIMESTAMP('2022-10-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(958, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(958, 5, 3);
INSERT INTO prescribed_treatments VALUES(958, 10, 1);
INSERT INTO payment_info VALUES (958, 10000, 680000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시윤', '230322-1111111', '서울특별시 노원구', '02-547-3053', '010-4966-8798', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 481, TO_TIMESTAMP('2022-10-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (959, TO_TIMESTAMP('2022-10-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(959, 300, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(959, 5, 1);
INSERT INTO payment_info VALUES (959, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 21, TO_TIMESTAMP('2022-10-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (960, TO_TIMESTAMP('2022-10-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(960, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(960, 1000, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(960, 3, 1);
INSERT INTO prescribed_treatments VALUES(960, 7, 3);
INSERT INTO payment_info VALUES (960, 3000, 460000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임예진', '680508-2222222', '서울특별시 강북구', '02-409-8265', '010-2885-6297', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 482, TO_TIMESTAMP('2022-10-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (961, TO_TIMESTAMP('2022-10-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(961, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (961, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 177, TO_TIMESTAMP('2022-10-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (962, TO_TIMESTAMP('2022-10-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_treatments VALUES(962, 6, 1);
INSERT INTO prescribed_treatments VALUES(962, 7, 2);
INSERT INTO payment_info VALUES (962, 5000, 350000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김채은', '260516-2222222', '서울특별시 은평구', '02-804-9666', '010-1449-3146', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 483, TO_TIMESTAMP('2022-10-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (963, TO_TIMESTAMP('2022-10-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(963, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(963, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(963, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(963, 5, 1);
INSERT INTO payment_info VALUES (963, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 417, TO_TIMESTAMP('2022-10-18 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (964, TO_TIMESTAMP('2022-10-18 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(964, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(964, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(964, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (964, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 230, TO_TIMESTAMP('2022-10-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (965, TO_TIMESTAMP('2022-10-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(965, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(965, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(965, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(965, 4, 3);
INSERT INTO prescribed_treatments VALUES(965, 2, 2);
INSERT INTO payment_info VALUES (965, 5000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임현우', '490208-1111111', '서울특별시 관악구', '02-563-2861', '010-9557-2495', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 484, TO_TIMESTAMP('2022-10-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (966, TO_TIMESTAMP('2022-10-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(966, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(966, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(966, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (966, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 345, TO_TIMESTAMP('2022-10-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (967, TO_TIMESTAMP('2022-10-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (967, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서우', '950318-1111111', '서울특별시 송파구', '02-150-9932', '010-5732-9870', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 485, TO_TIMESTAMP('2022-10-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (968, TO_TIMESTAMP('2022-10-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_medicines VALUES(968, 300, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(968, 8, 2);
INSERT INTO prescribed_treatments VALUES(968, 7, 1);
INSERT INTO payment_info VALUES (968, 30000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 388, TO_TIMESTAMP('2022-10-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (969, TO_TIMESTAMP('2022-10-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(969, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(969, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(969, 9, 3);
INSERT INTO prescribed_treatments VALUES(969, 7, 1);
INSERT INTO payment_info VALUES (969, 30000, 450000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 114, TO_TIMESTAMP('2022-10-20 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (970, TO_TIMESTAMP('2022-10-20 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(970, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(970, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(970, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (970, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허서아', '110102-3333333', '서울특별시 관악구', '02-778-9381', '010-5887-9017', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 486, TO_TIMESTAMP('2022-10-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (971, TO_TIMESTAMP('2022-10-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(971, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (971, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍다연', '860802-1111111', '서울특별시 성동구', '02-724-3805', '010-7832-9969', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 487, TO_TIMESTAMP('2022-10-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (972, TO_TIMESTAMP('2022-10-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(972, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(972, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(972, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (972, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 453, TO_TIMESTAMP('2022-10-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (973, TO_TIMESTAMP('2022-10-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(973, 600, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(973, 10, 1);
INSERT INTO prescribed_treatments VALUES(973, 1, 1);
INSERT INTO payment_info VALUES (973, 5000, 330000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시현', '460718-1111111', '서울특별시 중구', '02-690-8942', '010-3298-2613', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 488, TO_TIMESTAMP('2022-10-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (974, TO_TIMESTAMP('2022-10-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (974, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 4, TO_TIMESTAMP('2022-10-21 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (975, TO_TIMESTAMP('2022-10-21 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(975, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(975, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(975, 900, 1, 2, 5);
INSERT INTO payment_info VALUES (975, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김수연', '311117-2222222', '서울특별시 서초구', '02-542-8795', '010-1763-8194', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 489, TO_TIMESTAMP('2022-10-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (976, TO_TIMESTAMP('2022-10-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(976, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(976, 700, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(976, 3, 1);
INSERT INTO payment_info VALUES (976, 30000, 10000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 210, TO_TIMESTAMP('2022-10-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (977, TO_TIMESTAMP('2022-10-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(977, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (977, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 200, TO_TIMESTAMP('2022-10-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (978, TO_TIMESTAMP('2022-10-22 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(978, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(978, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(978, 300, 1, 3, 3);
INSERT INTO payment_info VALUES (978, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 119, TO_TIMESTAMP('2022-10-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (979, TO_TIMESTAMP('2022-10-22 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (979, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임시온', '760817-1111111', '서울특별시 송파구', '02-218-9130', '010-5472-2974', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 490, TO_TIMESTAMP('2022-10-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (980, TO_TIMESTAMP('2022-10-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(980, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (980, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 269, TO_TIMESTAMP('2022-10-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (981, TO_TIMESTAMP('2022-10-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(981, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(981, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (981, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임수연', '840503-2222222', '서울특별시 은평구', '02-238-6039', '010-5297-5331', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 491, TO_TIMESTAMP('2022-10-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (982, TO_TIMESTAMP('2022-10-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(982, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(982, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (982, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정가은', '091017-4444444', '서울특별시 은평구', '02-774-3405', '010-7994-7414', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 492, TO_TIMESTAMP('2022-10-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (983, TO_TIMESTAMP('2022-10-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(983, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(983, 5, 1);
INSERT INTO payment_info VALUES (983, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 73, TO_TIMESTAMP('2022-10-24 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (984, TO_TIMESTAMP('2022-10-24 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(984, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(984, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (984, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유진', '321207-2222222', '서울특별시 구로구', '02-707-7619', '010-4739-7527', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 493, TO_TIMESTAMP('2022-10-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (985, TO_TIMESTAMP('2022-10-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(985, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(985, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(985, 1000, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(985, 10, 2);
INSERT INTO payment_info VALUES (985, 3000, 460000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍시우', '820318-1111111', '서울특별시 용산구', '02-487-5960', '010-4895-4293', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 494, TO_TIMESTAMP('2022-10-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (986, TO_TIMESTAMP('2022-10-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (986, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 13, TO_TIMESTAMP('2022-10-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (987, TO_TIMESTAMP('2022-10-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(987, 100, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(987, 5, 1);
INSERT INTO prescribed_treatments VALUES(987, 7, 1);
INSERT INTO payment_info VALUES (987, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조민서', '790627-1111111', '서울특별시 송파구', '02-600-2655', '010-4639-6876', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 495, TO_TIMESTAMP('2022-10-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (988, TO_TIMESTAMP('2022-10-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(988, 1, 1);
INSERT INTO payment_info VALUES (988, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 114, TO_TIMESTAMP('2022-10-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (989, TO_TIMESTAMP('2022-10-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(989, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(989, 1000, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(989, 9, 2);
INSERT INTO prescribed_treatments VALUES(989, 6, 1);
INSERT INTO payment_info VALUES (989, 15000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이윤서', '880512-1111111', '서울특별시 강남구', '02-459-6210', '010-9100-7469', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 496, TO_TIMESTAMP('2022-10-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (990, TO_TIMESTAMP('2022-10-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (990, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 241, TO_TIMESTAMP('2022-10-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (991, TO_TIMESTAMP('2022-10-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(991, 300, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(991, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (991, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 448, TO_TIMESTAMP('2022-10-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (992, TO_TIMESTAMP('2022-10-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(992, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (992, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정지아', '790303-1111111', '서울특별시 용산구', '02-960-5965', '010-4201-4811', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 497, TO_TIMESTAMP('2022-10-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (993, TO_TIMESTAMP('2022-10-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(993, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(993, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(993, 5, 1);
INSERT INTO payment_info VALUES (993, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 429, TO_TIMESTAMP('2022-10-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (994, TO_TIMESTAMP('2022-10-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(994, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(994, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(994, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(994, 4, 2);
INSERT INTO prescribed_treatments VALUES(994, 10, 1);
INSERT INTO payment_info VALUES (994, 15000, 330000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박시연', '180828-4444444', '서울특별시 도봉구', '02-366-2917', '010-6041-1280', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 498, TO_TIMESTAMP('2022-10-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (995, TO_TIMESTAMP('2022-10-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(995, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(995, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (995, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 184, TO_TIMESTAMP('2022-10-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (996, TO_TIMESTAMP('2022-10-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(996, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(996, 8, 2);
INSERT INTO prescribed_treatments VALUES(996, 4, 3);
INSERT INTO payment_info VALUES (996, 10000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허진우', '921220-1111111', '서울특별시 종로구', '02-389-6101', '010-9493-8366', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 499, TO_TIMESTAMP('2022-10-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (997, TO_TIMESTAMP('2022-10-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (997, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 102, TO_TIMESTAMP('2022-10-29 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (998, TO_TIMESTAMP('2022-10-29 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(998, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(998, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (998, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이하은', '160715-4444444', '서울특별시 구로구', '02-541-5606', '010-8440-9758', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 500, TO_TIMESTAMP('2022-10-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (999, TO_TIMESTAMP('2022-10-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(999, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(999, 6, 2);
INSERT INTO prescribed_treatments VALUES(999, 9, 1);
INSERT INTO payment_info VALUES (999, 10000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 121, TO_TIMESTAMP('2022-10-29 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1000, TO_TIMESTAMP('2022-10-29 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1000, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (1000, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정시우', '630203-1111111', '서울특별시 동작구', '02-978-3312', '010-3523-6086', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 501, TO_TIMESTAMP('2022-10-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1001, TO_TIMESTAMP('2022-10-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1001, 5, 1);
INSERT INTO payment_info VALUES (1001, 10000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지원', '140302-4444444', '서울특별시 양천구', '02-178-6225', '010-5438-2280', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 502, TO_TIMESTAMP('2022-10-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1002, TO_TIMESTAMP('2022-10-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1002, 1000, 1, 3, 3);
INSERT INTO payment_info VALUES (1002, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 132, TO_TIMESTAMP('2022-10-31 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1003, TO_TIMESTAMP('2022-10-31 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1003, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1003, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍채윤', '170622-3333333', '서울특별시 성동구', '02-666-7618', '010-6100-1996', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 503, TO_TIMESTAMP('2022-10-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1004, TO_TIMESTAMP('2022-10-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1004, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1004, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (1004, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 166, TO_TIMESTAMP('2022-10-31 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1005, TO_TIMESTAMP('2022-10-31 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1005, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (1005, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조지훈', '481004-1111111', '서울특별시 동작구', '02-770-5554', '010-7075-9457', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 504, TO_TIMESTAMP('2022-10-31 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1006, TO_TIMESTAMP('2022-10-31 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1006, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정서진', '460616-1111111', '서울특별시 서대문구', '02-438-3940', '010-2396-3239', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 505, TO_TIMESTAMP('2022-11-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1007, TO_TIMESTAMP('2022-11-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1007, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 204, TO_TIMESTAMP('2022-11-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1008, TO_TIMESTAMP('2022-11-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1008, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 336, TO_TIMESTAMP('2022-11-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1009, TO_TIMESTAMP('2022-11-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1009, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1009, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1009, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (1009, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 32, TO_TIMESTAMP('2022-11-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1010, TO_TIMESTAMP('2022-11-02 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1010, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1010, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1010, 100, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1010, 3, 3);
INSERT INTO prescribed_treatments VALUES(1010, 2, 3);
INSERT INTO payment_info VALUES (1010, 5000, 180000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 342, TO_TIMESTAMP('2022-11-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1011, TO_TIMESTAMP('2022-11-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1011, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1011, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (1011, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강연우', '560812-2222222', '서울특별시 송파구', '02-527-7511', '010-1719-1661', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 506, TO_TIMESTAMP('2022-11-02 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1012, TO_TIMESTAMP('2022-11-02 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1012, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1012, 200, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1012, 1, 1);
INSERT INTO payment_info VALUES (1012, 3000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임하린', '580509-2222222', '서울특별시 동대문구', '02-140-6344', '010-2442-3355', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 507, TO_TIMESTAMP('2022-11-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1013, TO_TIMESTAMP('2022-11-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1013, 800, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1013, 5, 2);
INSERT INTO payment_info VALUES (1013, 30000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 366, TO_TIMESTAMP('2022-11-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1014, TO_TIMESTAMP('2022-11-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1014, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1014, 500, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1014, 2, 1);
INSERT INTO prescribed_treatments VALUES(1014, 10, 3);
INSERT INTO payment_info VALUES (1014, 3000, 740000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍서준', '980515-2222222', '서울특별시 동대문구', '02-349-4978', '010-6578-8240', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 508, TO_TIMESTAMP('2022-11-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1015, TO_TIMESTAMP('2022-11-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1015, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1015, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박하은', '391026-1111111', '서울특별시 관악구', '02-789-4034', '010-4353-8090', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 509, TO_TIMESTAMP('2022-11-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1016, TO_TIMESTAMP('2022-11-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1016, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1016, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1016, 300, 1, 1, 7);
INSERT INTO payment_info VALUES (1016, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 25, TO_TIMESTAMP('2022-11-03 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1017, TO_TIMESTAMP('2022-11-03 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1017, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1017, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1017, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (1017, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조은서', '250309-1111111', '서울특별시 동대문구', '02-301-1622', '010-4751-3619', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 510, TO_TIMESTAMP('2022-11-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1018, TO_TIMESTAMP('2022-11-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1018, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (1018, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조아윤', '700315-1111111', '서울특별시 구로구', '02-128-4906', '010-4911-8764', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 511, TO_TIMESTAMP('2022-11-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1019, TO_TIMESTAMP('2022-11-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1019, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 366, TO_TIMESTAMP('2022-11-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1020, TO_TIMESTAMP('2022-11-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1020, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 104, TO_TIMESTAMP('2022-11-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1021, TO_TIMESTAMP('2022-11-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (1021, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서영', '681216-1111111', '서울특별시 성북구', '02-224-4810', '010-2272-5995', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 512, TO_TIMESTAMP('2022-11-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1022, TO_TIMESTAMP('2022-11-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1022, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1022, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1022, 400, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1022, 9, 3);
INSERT INTO prescribed_treatments VALUES(1022, 5, 2);
INSERT INTO payment_info VALUES (1022, 10000, 600000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 399, TO_TIMESTAMP('2022-11-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1023, TO_TIMESTAMP('2022-11-05 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1023, 400, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1023, 6, 2);
INSERT INTO payment_info VALUES (1023, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 469, TO_TIMESTAMP('2022-11-06 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1024, TO_TIMESTAMP('2022-11-06 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1024, 900, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1024, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (1024, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박준서', '860207-1111111', '서울특별시 강남구', '02-355-1218', '010-3452-3050', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 513, TO_TIMESTAMP('2022-11-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1025, TO_TIMESTAMP('2022-11-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1025, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 121, TO_TIMESTAMP('2022-11-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1026, TO_TIMESTAMP('2022-11-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1026, 500, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1026, 200, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1026, 9, 3);
INSERT INTO prescribed_treatments VALUES(1026, 5, 1);
INSERT INTO payment_info VALUES (1026, 5000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장하윤', '960823-2222222', '서울특별시 송파구', '02-449-3521', '010-5341-9353', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 514, TO_TIMESTAMP('2022-11-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1027, TO_TIMESTAMP('2022-11-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1027, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 270, TO_TIMESTAMP('2022-11-07 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1028, TO_TIMESTAMP('2022-11-07 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1028, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1028, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (1028, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박수아', '390107-2222222', '서울특별시 강남구', '02-543-5180', '010-7309-1539', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 515, TO_TIMESTAMP('2022-11-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1029, TO_TIMESTAMP('2022-11-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1029, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1029, 1000, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1029, 900, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1029, 4, 1);
INSERT INTO prescribed_treatments VALUES(1029, 2, 2);
INSERT INTO payment_info VALUES (1029, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 479, TO_TIMESTAMP('2022-11-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1030, TO_TIMESTAMP('2022-11-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (1030, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 440, TO_TIMESTAMP('2022-11-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1031, TO_TIMESTAMP('2022-11-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1031, 1000, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1031, 900, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1031, 3, 1);
INSERT INTO prescribed_treatments VALUES(1031, 8, 3);
INSERT INTO payment_info VALUES (1031, 10000, 160000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 242, TO_TIMESTAMP('2022-11-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1032, TO_TIMESTAMP('2022-11-08 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1032, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허민재', '400514-1111111', '서울특별시 성동구', '02-196-2705', '010-7650-4450', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 516, TO_TIMESTAMP('2022-11-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1033, TO_TIMESTAMP('2022-11-09 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1033, 700, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1033, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1033, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (1033, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임하린', '790102-1111111', '서울특별시 도봉구', '02-353-8865', '010-1735-2060', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 517, TO_TIMESTAMP('2022-11-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1034, TO_TIMESTAMP('2022-11-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1034, 6, 3);
INSERT INTO payment_info VALUES (1034, 5000, 150000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이은우', '740409-1111111', '서울특별시 서대문구', '02-286-5819', '010-1141-1804', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 518, TO_TIMESTAMP('2022-11-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1035, TO_TIMESTAMP('2022-11-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1035, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (1035, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최서준', '351024-1111111', '서울특별시 강서구', '02-909-9992', '010-5753-5364', '화가 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 519, TO_TIMESTAMP('2022-11-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '심장이 빨리 뜀', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1036, TO_TIMESTAMP('2022-11-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1036, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1036, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (1036, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 157, TO_TIMESTAMP('2022-11-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1037, TO_TIMESTAMP('2022-11-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1037, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1037, 600, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1037, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (1037, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '강채윤', '200105-4444444', '서울특별시 강동구', '02-199-4346', '010-3829-4353', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 520, TO_TIMESTAMP('2022-11-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1038, TO_TIMESTAMP('2022-11-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1038, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (1038, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 151, TO_TIMESTAMP('2022-11-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1039, TO_TIMESTAMP('2022-11-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1039, 1, 1);
INSERT INTO prescribed_treatments VALUES(1039, 8, 3);
INSERT INTO payment_info VALUES (1039, 15000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조수연', '501210-2222222', '서울특별시 중구', '02-705-6368', '010-7898-7393', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 521, TO_TIMESTAMP('2022-11-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1040, TO_TIMESTAMP('2022-11-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1040, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (1040, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 354, TO_TIMESTAMP('2022-11-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1041, TO_TIMESTAMP('2022-11-11 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1041, 5, 1);
INSERT INTO prescribed_treatments VALUES(1041, 4, 3);
INSERT INTO payment_info VALUES (1041, 3000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김서현', '971019-1111111', '서울특별시 강서구', '02-270-7606', '010-9385-7925', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 522, TO_TIMESTAMP('2022-11-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1042, TO_TIMESTAMP('2022-11-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1042, 800, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1042, 4, 2);
INSERT INTO prescribed_treatments VALUES(1042, 7, 1);
INSERT INTO payment_info VALUES (1042, 10000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 398, TO_TIMESTAMP('2022-11-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1043, TO_TIMESTAMP('2022-11-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1043, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 358, TO_TIMESTAMP('2022-11-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1044, TO_TIMESTAMP('2022-11-11 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1044, 400, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1044, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (1044, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장지호', '050615-3333333', '서울특별시 동대문구', '02-119-3614', '010-5303-5002', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 523, TO_TIMESTAMP('2022-11-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1045, TO_TIMESTAMP('2022-11-12 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1045, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1045, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1045, 400, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1045, 8, 3);
INSERT INTO prescribed_treatments VALUES(1045, 6, 3);
INSERT INTO payment_info VALUES (1045, 3000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 68, TO_TIMESTAMP('2022-11-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1046, TO_TIMESTAMP('2022-11-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1046, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1046, 1000, 1, 2, 3);
INSERT INTO payment_info VALUES (1046, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 212, TO_TIMESTAMP('2022-11-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1047, TO_TIMESTAMP('2022-11-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1047, 800, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1047, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1047, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1047, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 356, TO_TIMESTAMP('2022-11-13 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1048, TO_TIMESTAMP('2022-11-13 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1048, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1048, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1048, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (1048, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '정서윤', '390612-2222222', '서울특별시 영등포구', '02-946-6889', '010-5324-2041', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 524, TO_TIMESTAMP('2022-11-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1049, TO_TIMESTAMP('2022-11-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1049, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1049, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1049, 800, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1049, 4, 1);
INSERT INTO payment_info VALUES (1049, 5000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 143, TO_TIMESTAMP('2022-11-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1050, TO_TIMESTAMP('2022-11-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1050, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1050, 300, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1050, 6, 2);
INSERT INTO prescribed_treatments VALUES(1050, 4, 3);
INSERT INTO payment_info VALUES (1050, 10000, 250000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 145, TO_TIMESTAMP('2022-11-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1051, TO_TIMESTAMP('2022-11-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1051, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (1051, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김은서', '360910-2222222', '서울특별시 영등포구', '02-483-2446', '010-1433-3354', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 525, TO_TIMESTAMP('2022-11-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1052, TO_TIMESTAMP('2022-11-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1052, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1052, 600, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1052, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (1052, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김유진', '490915-2222222', '서울특별시 관악구', '02-713-8954', '010-7930-7274', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 526, TO_TIMESTAMP('2022-11-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1053, TO_TIMESTAMP('2022-11-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1053, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1053, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1053, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 247, TO_TIMESTAMP('2022-11-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1054, TO_TIMESTAMP('2022-11-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1054, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1054, 500, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1054, 400, 1, 3, 5);
INSERT INTO payment_info VALUES (1054, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임은서', '570724-2222222', '서울특별시 마포구', '02-625-1127', '010-9842-8093', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 527, TO_TIMESTAMP('2022-11-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1055, TO_TIMESTAMP('2022-11-15 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (1055, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조아인', '520103-1111111', '서울특별시 서초구', '02-636-6676', '010-3186-4441', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 528, TO_TIMESTAMP('2022-11-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1056, TO_TIMESTAMP('2022-11-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1056, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1056, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1056, 500, 1, 1, 7);
INSERT INTO payment_info VALUES (1056, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임윤서', '870821-1111111', '서울특별시 송파구', '02-532-8872', '010-2504-6329', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 529, TO_TIMESTAMP('2022-11-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1057, TO_TIMESTAMP('2022-11-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1057, 8, 3);
INSERT INTO prescribed_treatments VALUES(1057, 3, 1);
INSERT INTO payment_info VALUES (1057, 10000, 160000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 253, TO_TIMESTAMP('2022-11-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1058, TO_TIMESTAMP('2022-11-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1058, 800, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1058, 8, 1);
INSERT INTO payment_info VALUES (1058, 15000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장승민', '360316-2222222', '서울특별시 성북구', '02-212-1309', '010-3453-1015', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 530, TO_TIMESTAMP('2022-11-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1059, TO_TIMESTAMP('2022-11-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1059, 500, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1059, 10, 1);
INSERT INTO prescribed_treatments VALUES(1059, 6, 3);
INSERT INTO payment_info VALUES (1059, 5000, 380000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 126, TO_TIMESTAMP('2022-11-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1060, TO_TIMESTAMP('2022-11-17 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1060, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1060, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1060, 800, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1060, 9, 1);
INSERT INTO prescribed_treatments VALUES(1060, 8, 2);
INSERT INTO payment_info VALUES (1060, 30000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장지율', '490918-2222222', '서울특별시 강남구', '02-362-6759', '010-2547-4207', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 531, TO_TIMESTAMP('2022-11-17 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1061, TO_TIMESTAMP('2022-11-17 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1061, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1061, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1061, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (1061, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 291, TO_TIMESTAMP('2022-11-17 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1062, TO_TIMESTAMP('2022-11-17 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1062, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1062, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (1062, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 478, TO_TIMESTAMP('2022-11-18 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1063, TO_TIMESTAMP('2022-11-18 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1063, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1063, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1063, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (1063, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지율', '500507-1111111', '서울특별시 노원구', '02-459-2984', '010-2766-7737', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 532, TO_TIMESTAMP('2022-11-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1064, TO_TIMESTAMP('2022-11-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1064, 900, 1, 3, 5);
INSERT INTO payment_info VALUES (1064, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 516, TO_TIMESTAMP('2022-11-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1065, TO_TIMESTAMP('2022-11-18 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1065, 800, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1065, 100, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1065, 700, 1, 3, 5);
INSERT INTO payment_info VALUES (1065, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임유나', '420620-2222222', '서울특별시 도봉구', '02-669-4353', '010-2179-1500', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 533, TO_TIMESTAMP('2022-11-19 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1066, TO_TIMESTAMP('2022-11-19 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1066, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1066, 900, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1066, 600, 1, 3, 3);
INSERT INTO payment_info VALUES (1066, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 476, TO_TIMESTAMP('2022-11-19 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1067, TO_TIMESTAMP('2022-11-19 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1067, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1067, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1067, 500, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1067, 10, 2);
INSERT INTO payment_info VALUES (1067, 5000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 432, TO_TIMESTAMP('2022-11-19 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1068, TO_TIMESTAMP('2022-11-19 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1068, 100, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1068, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1068, 900, 1, 1, 7);
INSERT INTO payment_info VALUES (1068, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 341, TO_TIMESTAMP('2022-11-20 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1069, TO_TIMESTAMP('2022-11-20 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1069, 1000, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1069, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (1069, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임하율', '811217-2222222', '서울특별시 강북구', '02-294-3498', '010-7406-3159', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 534, TO_TIMESTAMP('2022-11-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '어깨 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1070, TO_TIMESTAMP('2022-11-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1070, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1070, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1070, 800, 1, 3, 5);
INSERT INTO payment_info VALUES (1070, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 411, TO_TIMESTAMP('2022-11-20 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1071, TO_TIMESTAMP('2022-11-20 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1071, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1071, 200, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1071, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (1071, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 27, TO_TIMESTAMP('2022-11-21 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1072, TO_TIMESTAMP('2022-11-21 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1072, 300, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1072, 700, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1072, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1072, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 111, TO_TIMESTAMP('2022-11-21 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1073, TO_TIMESTAMP('2022-11-21 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1073, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (1073, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최예서', '580124-2222222', '서울특별시 광진구', '02-587-4320', '010-8554-1165', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 535, TO_TIMESTAMP('2022-11-22 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1074, TO_TIMESTAMP('2022-11-22 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (1074, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 37, TO_TIMESTAMP('2022-11-23 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1075, TO_TIMESTAMP('2022-11-23 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1075, 300, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1075, 400, 1, 2, 3);
INSERT INTO payment_info VALUES (1075, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 42, TO_TIMESTAMP('2022-11-23 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1076, TO_TIMESTAMP('2022-11-23 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1076, 300, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1076, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1076, 700, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1076, 1, 2);
INSERT INTO payment_info VALUES (1076, 5000, 200000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 458, TO_TIMESTAMP('2022-11-23 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1077, TO_TIMESTAMP('2022-11-23 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1077, 800, 1, 1, 7);
INSERT INTO payment_info VALUES (1077, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 453, TO_TIMESTAMP('2022-11-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1078, TO_TIMESTAMP('2022-11-24 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1078, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1078, 100, 1, 2, 5);
INSERT INTO payment_info VALUES (1078, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이수현', '680828-1111111', '서울특별시 강동구', '02-821-7330', '010-4678-7107', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 536, TO_TIMESTAMP('2022-11-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1079, TO_TIMESTAMP('2022-11-24 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1079, 5, 2);
INSERT INTO payment_info VALUES (1079, 5000, 300000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허서준', '200404-2222222', '서울특별시 동작구', '02-896-3588', '010-2307-7774', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 537, TO_TIMESTAMP('2022-11-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1080, TO_TIMESTAMP('2022-11-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1080, 400, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1080, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1080, 900, 1, 3, 3);
INSERT INTO payment_info VALUES (1080, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 257, TO_TIMESTAMP('2022-11-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1081, TO_TIMESTAMP('2022-11-25 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1081, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (1081, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장아린', '750725-1111111', '서울특별시 성동구', '02-188-9175', '010-9718-2450', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 538, TO_TIMESTAMP('2022-11-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1082, TO_TIMESTAMP('2022-11-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1082, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 354, TO_TIMESTAMP('2022-11-25 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1083, TO_TIMESTAMP('2022-11-25 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1083, 200, 1, 2, 5);
INSERT INTO payment_info VALUES (1083, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허건우', '211010-4444444', '서울특별시 서대문구', '02-602-9740', '010-7869-8143', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 539, TO_TIMESTAMP('2022-11-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1084, TO_TIMESTAMP('2022-11-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1084, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1084, 100, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1084, 3, 3);
INSERT INTO payment_info VALUES (1084, 5000, 30000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 94, TO_TIMESTAMP('2022-11-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1085, TO_TIMESTAMP('2022-11-25 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1085, 600, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1085, 900, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1085, 10, 2);
INSERT INTO prescribed_treatments VALUES(1085, 7, 2);
INSERT INTO payment_info VALUES (1085, 15000, 760000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김시아', '440816-2222222', '서울특별시 마포구', '02-554-4551', '010-9850-2728', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 540, TO_TIMESTAMP('2022-11-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1086, TO_TIMESTAMP('2022-11-26 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1086, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조시후', '361021-2222222', '서울특별시 송파구', '02-759-2422', '010-1726-5629', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 541, TO_TIMESTAMP('2022-11-26 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1087, TO_TIMESTAMP('2022-11-26 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1087, 800, 1, 2, 5);
INSERT INTO payment_info VALUES (1087, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 39, TO_TIMESTAMP('2022-11-26 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1088, TO_TIMESTAMP('2022-11-26 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1088, 100, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1088, 10, 2);
INSERT INTO payment_info VALUES (1088, 15000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 375, TO_TIMESTAMP('2022-11-27 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1089, TO_TIMESTAMP('2022-11-27 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1089, 200, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1089, 1000, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1089, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1089, 4, 2);
INSERT INTO payment_info VALUES (1089, 5000, 100000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조윤아', '141010-3333333', '서울특별시 송파구', '02-200-3742', '010-2966-3737', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 542, TO_TIMESTAMP('2022-11-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '코막힘', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1090, TO_TIMESTAMP('2022-11-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1090, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 189, TO_TIMESTAMP('2022-11-27 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1091, TO_TIMESTAMP('2022-11-27 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (1091, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 431, TO_TIMESTAMP('2022-11-27 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1092, TO_TIMESTAMP('2022-11-27 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1092, 700, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1092, 500, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1092, 1000, 1, 2, 5);
INSERT INTO payment_info VALUES (1092, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박서연', '230419-2222222', '서울특별시 성동구', '02-963-4573', '010-3342-9153', '말이 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 543, TO_TIMESTAMP('2022-11-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1093, TO_TIMESTAMP('2022-11-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '증상 심각하여 3차로 transfer');
COMMIT;
INSERT INTO payment_info VALUES (1093, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 233, TO_TIMESTAMP('2022-11-28 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1094, TO_TIMESTAMP('2022-11-28 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1094, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1094, 400, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1094, 3, 3);
INSERT INTO prescribed_treatments VALUES(1094, 7, 3);
INSERT INTO payment_info VALUES (1094, 5000, 480000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 419, TO_TIMESTAMP('2022-11-28 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1095, TO_TIMESTAMP('2022-11-28 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1095, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1095, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (1095, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '장민재', '220925-3333333', '서울특별시 마포구', '02-197-1756', '010-2135-7859', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 544, TO_TIMESTAMP('2022-11-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '재치기 심함', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1096, TO_TIMESTAMP('2022-11-28 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1096, 8, 3);
INSERT INTO prescribed_treatments VALUES(1096, 4, 2);
INSERT INTO payment_info VALUES (1096, 5000, 250000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김하은', '551015-1111111', '서울특별시 영등포구', '02-137-9467', '010-9909-6865', '말이 어눌');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 545, TO_TIMESTAMP('2022-11-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1097, TO_TIMESTAMP('2022-11-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1097, 400, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1097, 100, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1097, 600, 1, 3, 5);
INSERT INTO payment_info VALUES (1097, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 66, TO_TIMESTAMP('2022-11-29 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1098, TO_TIMESTAMP('2022-11-29 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1098, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1098, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (1098, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박채은', '801026-1111111', '서울특별시 동작구', '02-361-2366', '010-8718-4814', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 546, TO_TIMESTAMP('2022-11-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1099, TO_TIMESTAMP('2022-11-30 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1099, 100, 1, 3, 3);
INSERT INTO payment_info VALUES (1099, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 338, TO_TIMESTAMP('2022-11-30 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1100, TO_TIMESTAMP('2022-11-30 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1100, 700, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1100, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (1100, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이이안', '381207-2222222', '서울특별시 은평구', '02-600-1347', '010-3425-6920', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 547, TO_TIMESTAMP('2022-11-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1101, TO_TIMESTAMP('2022-11-30 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1101, 200, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1101, 7, 1);
INSERT INTO prescribed_treatments VALUES(1101, 6, 1);
INSERT INTO payment_info VALUES (1101, 5000, 200000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박다은', '380816-2222222', '서울특별시 종로구', '02-290-6884', '010-7967-3540', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 548, TO_TIMESTAMP('2022-12-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1102, TO_TIMESTAMP('2022-12-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1102, 300, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1102, 9, 3);
INSERT INTO payment_info VALUES (1102, 10000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 364, TO_TIMESTAMP('2022-12-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1103, TO_TIMESTAMP('2022-12-01 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1103, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1103, 300, 1, 2, 5);
INSERT INTO payment_info VALUES (1103, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 118, TO_TIMESTAMP('2022-12-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1104, TO_TIMESTAMP('2022-12-01 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1104, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1104, 5, 1);
INSERT INTO payment_info VALUES (1104, 10000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 191, TO_TIMESTAMP('2022-12-01 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1105, TO_TIMESTAMP('2022-12-01 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1105, 600, 1, 2, 3);
INSERT INTO payment_info VALUES (1105, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최시우', '681024-1111111', '서울특별시 도봉구', '02-468-6125', '010-8052-4276', '장난기 많음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 549, TO_TIMESTAMP('2022-12-02 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1106, TO_TIMESTAMP('2022-12-02 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1106, 400, 1, 1, 7);
INSERT INTO payment_info VALUES (1106, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최소율', '050618-4444444', '서울특별시 종로구', '02-957-1104', '010-8596-6730', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 550, TO_TIMESTAMP('2022-12-03 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '오심', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1107, TO_TIMESTAMP('2022-12-03 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1107, 200, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1107, 100, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1107, 1, 3);
INSERT INTO prescribed_treatments VALUES(1107, 6, 2);
INSERT INTO payment_info VALUES (1107, 5000, 400000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김주원', '410902-2222222', '서울특별시 강서구', '02-295-1600', '010-8300-1101', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 551, TO_TIMESTAMP('2022-12-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1108, TO_TIMESTAMP('2022-12-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1108, 500, 1, 2, 5);
INSERT INTO prescribed_treatments VALUES(1108, 5, 2);
INSERT INTO payment_info VALUES (1108, 30000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 301, TO_TIMESTAMP('2022-12-03 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1109, TO_TIMESTAMP('2022-12-03 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1109, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (1109, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 317, TO_TIMESTAMP('2022-12-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1110, TO_TIMESTAMP('2022-12-04 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO payment_info VALUES (1110, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조유주', '260105-1111111', '서울특별시 양천구', '02-166-9331', '010-5705-9844', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 552, TO_TIMESTAMP('2022-12-04 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1111, TO_TIMESTAMP('2022-12-04 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1111, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1111, 200, 1, 1, 7);
INSERT INTO payment_info VALUES (1111, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 163, TO_TIMESTAMP('2022-12-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1112, TO_TIMESTAMP('2022-12-04 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1112, 400, 1, 2, 5);
INSERT INTO payment_info VALUES (1112, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '김시연', '781022-2222222', '서울특별시 동대문구', '02-792-9632', '010-9735-6164', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 553, TO_TIMESTAMP('2022-12-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1113, TO_TIMESTAMP('2022-12-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1113, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1113, 600, 1, 2, 5);
INSERT INTO payment_info VALUES (1113, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 79, TO_TIMESTAMP('2022-12-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1114, TO_TIMESTAMP('2022-12-05 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1114, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1114, 200, 1, 2, 3);
INSERT INTO prescribed_treatments VALUES(1114, 6, 3);
INSERT INTO payment_info VALUES (1114, 5000, 150000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 210, TO_TIMESTAMP('2022-12-05 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1115, TO_TIMESTAMP('2022-12-05 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1115, 300, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1115, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1115, 4, 1);
INSERT INTO payment_info VALUES (1115, 5000, 50000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍수아', '840111-2222222', '서울특별시 광진구', '02-882-1122', '010-8860-2296', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 554, TO_TIMESTAMP('2022-12-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '감기 기운', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1116, TO_TIMESTAMP('2022-12-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1116, 300, 1, 3, 5);
INSERT INTO payment_info VALUES (1116, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 353, TO_TIMESTAMP('2022-12-06 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1117, TO_TIMESTAMP('2022-12-06 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1117, 1000, 1, 3, 5);
INSERT INTO payment_info VALUES (1117, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최민성', '010628-4444444', '서울특별시 서대문구', '02-994-5244', '010-9985-2649', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 555, TO_TIMESTAMP('2022-12-06 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1118, TO_TIMESTAMP('2022-12-06 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (1118, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍지안', '390507-1111111', '서울특별시 중랑구', '02-827-2879', '010-7926-9078', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 556, TO_TIMESTAMP('2022-12-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1119, TO_TIMESTAMP('2022-12-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1119, 800, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1119, 400, 1, 3, 3);
INSERT INTO payment_info VALUES (1119, 10000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 166, TO_TIMESTAMP('2022-12-07 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1120, TO_TIMESTAMP('2022-12-07 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1120, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (1120, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 219, TO_TIMESTAMP('2022-12-07 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1121, TO_TIMESTAMP('2022-12-07 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L67', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1121, 500, 1, 3, 3);
INSERT INTO payment_info VALUES (1121, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이지민', '630428-1111111', '서울특별시 노원구', '02-208-2356', '010-8960-2501', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 557, TO_TIMESTAMP('2022-12-08 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1122, TO_TIMESTAMP('2022-12-08 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1122, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1122, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1122, 400, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1122, 4, 1);
INSERT INTO prescribed_treatments VALUES(1122, 10, 2);
INSERT INTO payment_info VALUES (1122, 10000, 510000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임우진', '390519-2222222', '서울특별시 중랑구', '02-862-7555', '010-1998-1639', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 558, TO_TIMESTAMP('2022-12-09 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1123, TO_TIMESTAMP('2022-12-09 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1123, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1123, 900, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1123, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (1123, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박민지', '340117-1111111', '서울특별시 서대문구', '02-792-4800', '010-5179-7530', '말이 적음');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 559, TO_TIMESTAMP('2022-12-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '머리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1124, TO_TIMESTAMP('2022-12-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1124, 15000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 232, TO_TIMESTAMP('2022-12-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1125, TO_TIMESTAMP('2022-12-09 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1125, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1125, 1000, 1, 1, 7);
INSERT INTO payment_info VALUES (1125, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최연우', '200107-3333333', '서울특별시 관악구', '02-216-4793', '010-1525-8334', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 560, TO_TIMESTAMP('2022-12-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1126, TO_TIMESTAMP('2022-12-10 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO payment_info VALUES (1126, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '박연우', '870425-1111111', '서울특별시 노원구', '02-571-5287', '010-3294-2342', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 561, TO_TIMESTAMP('2022-12-10 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1127, TO_TIMESTAMP('2022-12-10 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '3일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1127, 7, 3);
INSERT INTO prescribed_treatments VALUES(1127, 6, 1);
INSERT INTO payment_info VALUES (1127, 10000, 500000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '최아윤', '101003-4444444', '서울특별시 강북구', '02-104-8396', '010-1753-6877', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 562, TO_TIMESTAMP('2022-12-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1128, TO_TIMESTAMP('2022-12-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1128, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1128, 600, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1128, 900, 1, 1, 7);
INSERT INTO prescribed_treatments VALUES(1128, 6, 1);
INSERT INTO payment_info VALUES (1128, 30000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 329, TO_TIMESTAMP('2022-12-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1129, TO_TIMESTAMP('2022-12-10 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1129, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1129, 500, 1, 2, 5);
INSERT INTO payment_info VALUES (1129, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 34, TO_TIMESTAMP('2022-12-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '아랫배 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1130, TO_TIMESTAMP('2022-12-11 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1130, 1000, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1130, 600, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1130, 700, 1, 2, 3);
INSERT INTO payment_info VALUES (1130, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 534, TO_TIMESTAMP('2022-12-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1131, TO_TIMESTAMP('2022-12-12 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1131, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임유찬', '310712-2222222', '서울특별시 관악구', '02-973-7178', '010-3605-7012', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 563, TO_TIMESTAMP('2022-12-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1132, TO_TIMESTAMP('2022-12-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'L65', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1132, 1000, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1132, 10, 2);
INSERT INTO payment_info VALUES (1132, 10000, 460000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 218, TO_TIMESTAMP('2022-12-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1133, TO_TIMESTAMP('2022-12-12 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1133, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1133, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1133, 700, 1, 3, 3);
INSERT INTO payment_info VALUES (1133, 15000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임아린', '960101-2222222', '서울특별시 강동구', '02-614-9460', '010-5308-3932', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 564, TO_TIMESTAMP('2022-12-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1134, TO_TIMESTAMP('2022-12-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO payment_info VALUES (1134, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 81, TO_TIMESTAMP('2022-12-13 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1135, TO_TIMESTAMP('2022-12-13 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1135, 900, 1, 2, 3);
INSERT INTO payment_info VALUES (1135, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이시아', '071010-3333333', '서울특별시 금천구', '02-820-5059', '010-7918-6399', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 565, TO_TIMESTAMP('2022-12-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1136, TO_TIMESTAMP('2022-12-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '차후 지켜볼 예정');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1136, 700, 1, 1, 7);
INSERT INTO payment_info VALUES (1136, 30000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 466, TO_TIMESTAMP('2022-12-13 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1137, TO_TIMESTAMP('2022-12-13 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'R63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1137, 400, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1137, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (1137, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '조가은', '210615-3333333', '서울특별시 광진구', '02-357-9646', '010-1364-7841', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 566, TO_TIMESTAMP('2022-12-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1138, TO_TIMESTAMP('2022-12-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'E66', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1138, 200, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1138, 900, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1138, 4, 2);
INSERT INTO payment_info VALUES (1138, 5000, 100000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 58, TO_TIMESTAMP('2022-12-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1139, TO_TIMESTAMP('2022-12-14 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '일주일 뒤에 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1139, 100, 1, 3, 5);
INSERT INTO prescribed_medicines VALUES(1139, 900, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1139, 500, 1, 3, 5);
INSERT INTO payment_info VALUES (1139, 10000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍예은', '220522-3333333', '서울특별시 서초구', '02-920-3689', '010-8829-7959', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 567, TO_TIMESTAMP('2022-12-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1140, TO_TIMESTAMP('2022-12-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '내일 다시 오라고 했음');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1140, 400, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1140, 900, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1140, 800, 1, 3, 3);
INSERT INTO payment_info VALUES (1140, 3000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 455, TO_TIMESTAMP('2022-12-14 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1141, TO_TIMESTAMP('2022-12-14 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1141, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1141, 500, 1, 2, 3);
INSERT INTO prescribed_medicines VALUES(1141, 400, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1141, 7, 2);
INSERT INTO payment_info VALUES (1141, 3000, 300000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 244, TO_TIMESTAMP('2022-12-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '무릎 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1142, TO_TIMESTAMP('2022-12-14 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'J00', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO payment_info VALUES (1142, 5000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '홍하율', '740404-2222222', '서울특별시 구로구', '02-782-8553', '010-8844-1913', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 568, TO_TIMESTAMP('2022-12-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '발가락 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1143, TO_TIMESTAMP('2022-12-15 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A41', '삼육내과의원', '김두유', '약만 잘 먹으면 문제 없을 듯');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1143, 200, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1143, 800, 1, 2, 3);
INSERT INTO payment_info VALUES (1143, 30000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '허지유', '450305-2222222', '서울특별시 강북구', '02-192-9359', '010-7365-1981', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 569, TO_TIMESTAMP('2022-12-15 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '허리 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1144, TO_TIMESTAMP('2022-12-15 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1144, 700, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1144, 100, 1, 3, 3);
INSERT INTO prescribed_medicines VALUES(1144, 800, 1, 3, 5);
INSERT INTO prescribed_treatments VALUES(1144, 7, 3);
INSERT INTO payment_info VALUES (1144, 3000, 450000, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '임지민', '841124-2222222', '서울특별시 마포구', '02-232-7361', '010-6396-6691', '');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 570, TO_TIMESTAMP('2022-12-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1145, TO_TIMESTAMP('2022-12-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'K51', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1145, 200, 1, 2, 3);
INSERT INTO payment_info VALUES (1145, 5000, 0, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 463, TO_TIMESTAMP('2022-12-16 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), '결핵', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1146, TO_TIMESTAMP('2022-12-16 12:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'A05', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1146, 800, 1, 1, 7);
INSERT INTO prescribed_medicines VALUES(1146, 400, 1, 3, 3);
INSERT INTO prescribed_treatments VALUES(1146, 2, 1);
INSERT INTO payment_info VALUES (1146, 15000, 50000, 1);
COMMIT;

INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 288, TO_TIMESTAMP('2022-12-16 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), '가슴 아픔', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1147, TO_TIMESTAMP('2022-12-16 15:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'T88', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_medicines VALUES(1147, 500, 1, 2, 5);
INSERT INTO prescribed_medicines VALUES(1147, 300, 1, 2, 3);
INSERT INTO payment_info VALUES (1147, 3000, 0, 1);
COMMIT;

INSERT INTO patient_info VALUES (PATIENT_ID_SEQ.NEXTVAL, '이예린', '360319-2222222', '서울특별시 마포구', '02-935-8890', '010-9293-4854', '지갑을 자주 두고 감');
COMMIT;
INSERT INTO diagnosis_registration VALUES (REGISTRATION_ID_SEQ.NEXTVAL, 571, TO_TIMESTAMP('2022-12-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), '', 1);
COMMIT;
INSERT INTO diagnosis_record VALUES (1148, TO_TIMESTAMP('2022-12-16 18:05:00', 'YYYY-MM-DD HH24:MI:SS'), 'Y63', '삼육내과의원', '김두유', '');
COMMIT;
INSERT INTO prescribed_treatments VALUES(1148, 6, 2);
INSERT INTO prescribed_treatments VALUES(1148, 7, 1);
INSERT INTO payment_info VALUES (1148, 10000, 250000, 1);
COMMIT;