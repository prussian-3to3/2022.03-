# DML(Data Manipulation Language)

- **CRUD** : 첫 번째 query 토픽에서 다뤘던 개념을 복습하자면, 데이터를 다루는 명령의 약자.
  - DML을 뜻하는 경우가 많지만, 기본적인 데이터 입출력, 삭제를 포괄하는 단어다.
  - 지금까지 다룬 `SELECT` 절은 CRUD 개념 중 R(Read)에 속한다.
- DML은 CRUD가 가능한 명령이다. 이 점을 기억하며 하나씩 살펴본다.

|  의미  | 해당 DML 명령 |
| :----: | :-----------: |
| Create |   `INSERT`    |
|  Read  |   `SELECT`    |
| Update |   `UPDATE`    |
| Delete |   `DELETE`    |

- DDL을 본격적으로 배우진 않았지만, 직접 테이블을 만들고 다뤄볼 예정이니 **`example.sql`을 필독**하는 것을 권장한다.

---

## `COMMIT`

- TCL(Transaction Control Language), DCL(Data Control Language) 등으로 일컫는 **제어 명령**이다.
- DDL 명령의 경우 commit이 필요하지 않으나, DML 명령의 경우 메모리 상에 확보한 **세션 공간 내에서만 작업**이 이루어지고, DB에 **_바로 적용이 되지 않_**기 때문에 **commit이 필수**적이다.
  - DB설정에 따라 DML 명령 시에도 데이터가 즉시 적용되는 경우가 있으나, 기본값은 auto-commit이 되지 않는 상태이다.

## Create : `INSERT`

- 이미 만들어진 테이블에 데이터를 **추가**한다.

```sql
INSERT INTO tbl_name [(
    col1_name, col2_name....
)] VALUES (/* 입력할 각 데이터 나열 */);
```

- **필드이름 지정** : 필드 나열 순서대로 데이터 입력
- **필드이름 미지정** : 모든 필드의 데이터 입력
  - 입력 순서는 테이블이 작성되었을 시점을 기준으로 함

## Update : `UPDATE`

- 기존 데이터의 내용을 수정한다.
- **서브 쿼리(sub query)**를 이용해 여러 필드의 데이터를 대체할 수도 있다.
- `INSERT` 절과 달리 나열하는 데이터는 **순서가 무관**하다.

```sql
-- 기본
UPDATE tbl_name
SET col1_name = data1, col2_name = data2 ...
[WHERE /* 조건식 */] -- 조건식이 없는 경우 일괄 적용

-- 서브 쿼리 사용 시
UPDATE tbl_name
SET (col1, col2 ...) = (
    SELECT source_col1, source_col2....
    FROM source_tbl
    WHERE /* 조건 식 */
)
```

> - **수정을 원치 않지만, 어쩔 수 없이 `UPDATE` 명령을 실행해야 한다면?**
>   - `SET` 구문 이후의 부분을 col_name = col_name 으로 지정하면 데이터가 지정된다.

## Delete : `DELETE`

- 현재 데이터 중 불필요한 데이터를 **삭제**한다.
- **_행(row) 하나가 통째로 삭제_**되니 주의가 필요한 명령이다.
- 조건을 기입하지 않는 경우, `TRUNCATE` 명령과 같이 **_테이블 전체 내용이 일괄적으로 제거_**된다.
- 보통 실무에서는 **구분자가 되는 필드(column)을 준비**하고, 해당 값을 변경시키는 편이며, **_`DELETE` 명령을 직접적으로 사용하는 것을 지양하는 편_**이다.
  - 검색 기록 등의 편의성 기능의 경우 `DELETE`를 사용하는 경우도 있다. (하지만 LLM 등의 발전으로 해당 정보도 활용(feeding)을 위해 보존하는 편이니 주의)
  - 구분자로써는 `isShow`, `is_del` 등 직관적인 이름을 사용한다.
  - 보편적으로 해당 컬럼(field)의 기본값을 **보임**을 뜻하는 값으로 설정하고, 삭제 **_처리_**가 필요할 때 **비공개**를 뜻하는 값으로 `UPDATE` 한다.
  - 리스트, 세부 페이지 등 `SELECT` 시에는 해당 컬럼(field)을 **보임**을 뜻하는 값으로 필터링 하여 조회하는 방식을 사용한다.

```sql
DELETE FROM tbl_name
[WHERE /* 조건 식 */] -- 선택 사항이나 웬만하면 기재
```

---

## DML을 마치며...

- `DELETE` 명령을 대체하는 공개/비공개 구분자 등에서 **구분자가 되는 값을 제한**하기 위해 `CHECK` 명령을 사용한다. (이는 제약조건 토픽 `10-constraint`에서 후술)

### 토막 지식 : 테이블 설계

- 아래의 내용은 정보처리기사, SQLD/SQLP 등에서도 등장한다.

1. **개념적 설계** : 추상적인 개념 설계. `개념적 데이터 모델`을 만든다.
2. **논리적 설계** : `개념적 데이터 모델`을 기반으로 물리적 저장장치에 저장 가능한, 특정 DB가 지원하는 `논리적 자료구조`로 변환.
   - **데이터 타입**, 데이터 간 **관계가 표현**되는 단계
   - **ER-D**, 테이블 **명세서** 등이 도출될 수 있다.
3. **물리적 설계** : 논리적 설계의 결과를 물리적으로 구현한다.
   - **SQL 문서**(작성된 DDL 질의 명령) 등이 도출될 수 있다.

### 토막 지식 : 정규화 과정

- 아래의 내용들은 가볍게 다루는 항목들이다. 꽤 복잡한 내용이니 관심이 있다면 별도로 알아보는 것을 권장한다.

1. **제 1 정규화**(1NF) : entity가 갖는 속성은 원자값(다른 형태로 나눌 수 없는값)이여야 한다.
2. **제 2 정규화**(2NF) : **제 1 정규화를 만족**하며, 기본키에 대해 모든 key는 **_완전 함수 종속_**이여야 한다.

   - **기본키**(primary key) : 특정 행(row)을 구분할 수 있는 데이터
   - **완전 함수 종속** : 기본키를 알면 특정 행(row)를 조회할 수 있는 상태

3. **제 3 정규화**(3NF) : **제 2 정규화를 만족**하며, **이행적 함수 종속**을 제거해야 한다.

   - **이행적 함수 종속** : 특정 필드(field)의 데이터를 알면 같은 행(row), 다른 필드의 데이터들도 연계되어 결정되는 상태

4. **BCNF**(Boyce-codd Normal Form) : **제 3 정규화를 만족**하며, 모든 결정자가 후보키 집합에 속해야 한다.
   - **결정자** : 속성의 값이 정해지면 다른 속성의 값이 유일하게 결정되는 속성(또는 속성의 집합)
   - **후보키 집합** : 모든 행을 유일하게 식별할 수 있는 최소한의 속성 집합
   - **모든 결정자가 후보키 집합에 속한다** : **모든 유일값들이 해당 행(row)를 구분할 수 있는 값**이여야 한다.
5. **제 4, 5 정규화** : 실무에서 거의 사용되지 않으므로 생략한다.

### DB 명령 종류 가볍게 복습하기

1. **DML**(Data Manipulation Language) : CRUD
2. **DDL**(Data Definition Language) : 데이터 자체가 아닌, **테이블의 구조**적인 것에 대해 작업한다.
   - `CREATE`, `ALTER`, `DROP`: 개체(Entity) 생성, 수정, 삭제
   - `TRUNCATE` : 테이블 내 데이터 모두 삭제 (테이블 외 타 객체엔 사용 불가)
     - `DELETE FROM` 보다 성능이 뛰어나다.
     - 실무에서는 **메모리 확보를 목적**으로 만료된 log 테이블이나, 데이터 이전이 완료된 테이블의 **이력을 남기면서 데이터를 삭제하고 싶을 때** 실행하는 명령이다.
3. **DCL**(Data Control Language) : `GRANT`, `REVOKE` 명령으로 **유저의 권한을 제어**할 수 있다.
4. **TCL**(Transaction Control Language) : `COMMIT`, `ROLLBACK`, `SAVEPOINT` 명령으로 DB **트랜잭션(transaction)을 제어**한다.
   - 교재, 강의 마다 TCL과 DCL을 분리하기도, TCL을 DCL의 하위 개념으로 보거나 통합해서 보기도 한다.
5. **PL/SQL**(oracle) : 타 프로그래밍 언어와 같이 **변수, 함수 등을 이용**하여 데이터를 다루는 oracle의 언어
   - 해당 레포지토리는 입문용 레포지토리이기 때문에 다루지 않는다.
