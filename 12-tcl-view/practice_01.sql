/* ========================= [ 쿼리 연습 정답 ] ========================= */
/*
    1.  아래의 내용 수행

        i.  view emp_dno 생성

            emp_dno 내용 :
                emp 테이블 사원들의
                사번, 사원 이름, 부서 번호, 부서 이름, 부서 위치 조회

        ii. emp_dno 뷰를 통해 데이터 입력 시도 (오류 발생 시 성공)

            입력 데이터 :
                사번        - 9999
                이름        - 'KIM'
                부서번호    - 10,
                부서 이름   - 'ACCOUNTING'
                부서 위치   - 'NEW YORK'
*/
-- 1-1. view emp_dno 생성
CREATE VIEW emp_dno AS
    SELECT empno, ename, emp.deptno, dname, loc
    FROM emp e, dept d
    WHERE e.deptno = d.deptno;

-- 1-2. emp_dno 뷰를 통해 데이터 입력 시도
INSERT INTO emp_dno
VALUES (9999, 'KIM', 10, 'ACCOUNTING', 'NEW YORK');

/*
    2.  아래의 내용 수행
        
        i.  view dno 생성
        
            dno 내용 :
                부서번호가 10인 사원들의
                사번, 사원 이름, 급여, 커미션 조회

        ii. dno 뷰를 통해 데이터 입력 시도 (데이터 입력 시 성공)
        
            입력 데이터 :
                사번        - 9998
                이름        - 'LEE'
                급여        - 3000
                커미션      - 500

        iii. emp 테이블 조회(단, 사번이 큰 순서대로 조회)
*/
-- 2-1. view dno 생성
CREATE VIEW dno10 AS
    SELECT empno, ename, sal, comm
    FROM emp
    WHERE deptno = 10;

-- 2-2. dno 뷰를 통해 데이터 입력 시도
INSERT INTO dno10
VALUES (9998, 'LEE', 3000, 500);

-- 2-3. emp 테이블을 조회하여 데이터 확인
SELECT * FROM emp ORDER BY empno DESC;

/*
    3.  아래의 내용 수행
    
        i.  emp 테이블을 복사한 employee 테이블 생성
        ii. 테이블 생성 시 기본키, 참조키 제약조건 추가
        iii. view dno10 생성

            dno10 내용 :
                부서번호가 10인 사원들의
                사번, 사원 이름, 급여, 커미션, 부서 번호 조회
                (단, 데이터 수정 불가)

        iv.  dno10 뷰를 조회
        v.   dno10 뷰를 통해 데이터 변경시도 (오류 발생 시 성공)

            변경 데이터 :
                CLARK 사원  - 커미션 500 증가(기존 커미션이 없는 경우 500으로 설정)
                KING 사원   - 부서번호 40으로 변경
*/
-- 3-1. employee 테이블 생성
CREATE TABLE employee
AS SELECT * FROM emp;

-- 3-2. 기본키, 참조키 제약조건 추가
ALTER TABLE employee -- PK
ADD CONSTRAINT EMPLO_NO_PK PRIMARY KEY(empno);

ALTER TABLE employee ADD -- FK
CONSTRAINT EMPLO_DNO_FK FOREIGN KEY(deptno) REFERENCES dept(deptno);

-- 3-3. view dno10 생성
CREATE OR REPLACE VIEW dno10 AS
    SELECT empno, ename, sal, comm, deptno
    FROM employee
    WHERE deptno = 10
WITH CHECK OPTION;

-- 3-4. dno10 뷰 조회
SELECT * FROM dno10;

-- 3-5. dno10 뷰에 데이터 변경시도
UPDATE dno10
SET comm = NVL(comm + 500, 500)
WHERE ename = 'CLARK';

UPDATE dno10
SET deptno = 40
WHERE ename = 'KING';

rollback; -- 연습문제 풀이 후 무조건 실행