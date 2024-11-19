--Metadata-----------------------------------------------------------------
---------------------------------------------------------------------------
create database Metadata1;

use Metadata1;

--Data flow
create table data_flow (
	ID int not null identity (1,1),
	name varchar(55) not null,
	CET datetime,
	LSET datetime,
	constraint PK_DATA_FLOW primary key clustered (ID)
)

select* from data_flow;
truncate table data_flow;

insert into data_flow values ('LopHoc', '2021-10-1', '2021-10-1 16:30')
insert into data_flow values ('HocSinh', '2021-10-1', '2021-10-01 16:30')
insert into data_flow values ('MonHoc', '2021-10-1', '2021-10-01 16:30')
insert into data_flow values ('Diem', '2021-10-1', '2021-10-01 16:30')

--Data flow NDS
create table data_flow_nds (
	ID int not null identity (1,1),
	name varchar(55) not null,
	CET datetime,
	LSET datetime,
	constraint PK_DATA_FLOW_NDS primary key clustered (ID)
)

truncate table data_flow_nds;

insert into data_flow_nds values ('LopHocNDS', '2021-10-1', '2021-10-1 16:30')
insert into data_flow_nds values ('HocSinhNDS', '2021-10-1', '2021-10-01 16:30')
insert into data_flow_nds values ('MonHocNDS', '2021-10-1', '2021-10-01 16:30')
insert into data_flow_nds values ('DiemNDS', '2021-10-1', '2021-10-01 16:30')

--Bảng kiểm tra chất lượng dữ liệu
CREATE TABLE DataQualityLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50),    
    ColumnName NVARCHAR(50),  
    RuleDescription NVARCHAR(255),   
    InvalidRecordCount INT,            
    CheckDate DATETIME DEFAULT GETDATE()
);

select* from DataQualityLog;

--Bảng lưu trạng thái ETL
CREATE TABLE ETLProcessLog (
    ProcessID INT IDENTITY(1,1) PRIMARY KEY,
    ProcessName NVARCHAR(50),
    Status NVARCHAR(50),                    -- Trạng thái (Success, Fail, Running)
    StartTime DATETIME,
    EndTime DATETIME,
    ErrorMessage NVARCHAR(MAX)
);

select* from ETLProcessLog;

--NDS-----------------------------------------------------------------------------
----------------------------------------------------------------------------------

create database NDS;
use NDS;

create table LopHocNDS (
	MaLop_SK int identity(1,1) primary key,
	MaLop_NK nvarchar(255),
	TenLop nvarchar(255),
	SiSo int,
	CreatedAt datetime,
	UpdatedAt datetime,
	SourceID int
)

create table HocSinhNDS (
	MaHS_SK int identity(1,1) primary key,
	MaHS_NK nvarchar(255),
	TenHS nvarchar(255),
	NgaySinh datetime,
	GioiTinh nvarchar(255),
	MaLop_SK int,
	foreign key (MaLop_SK) references LopHocNDS (MaLop_SK),
	CreatedAt datetime,
	UpdatedAt datetime,
	SourceID int
)

create table MonHocNDS (
	MaMH_SK int identity(1,1) primary key,
	MaMH_NK nvarchar(255),
	TenMH nvarchar(255),
	SoTC int,
	CreatedAt datetime,
	UpdatedAt datetime,
	SourceID int
)

create table DiemNDS (
	MaHS_SK int,
	MaMH_SK int,
	Diem float,
	CreatedAt datetime,
	UpdatedAt datetime,
	SourceID int
	foreign key (MaHS_SK) references HocSinhNDS (MaHS_SK),
	foreign key (MaMH_SK) references MonHocNDS (MaMH_SK)
)

select* from HocSinhNDS;
select* from LopHocNDS;
select* from MonHocNDS;
select* from DiemNDS;

--DDS--------------------------------------------------------------------
-------------------------------------------------------------------------
create database DDS;
use DDS;

create table dimHocSinh (
	MaHS_SK int primary key,
	TenHS nvarchar(255),
	NgaySinh datetime,
	GioiTinh nvarchar(255)
)

create table dimLopHoc (
	MaLH_SK int primary key, 
	TenLop nvarchar(255),
	SiSo int
)

create table dimMonHoc (
	MaMH_SK int primary key,
	TenMH nvarchar(255),
	SoTC int,
	Status int
)

create table factThongKe (
	MaMH_SK int,
	MaLH_SK int,
	SoLuongDau int,
	SoLuongRot int,
	foreign key (MaMH_SK) references dimMonHoc(MaMH_SK),
	foreign key (MaLH_SK) references dimLopHoc (MaLH_SK)
)

drop table factThongKe;
drop table dimHocSinh;
drop table dimMonHoc;
drop table dimLopHoc;

select* from factThongKe;
select* from dimHocSinh;
select* from dimMonHoc;
select* from dimLopHoc;


--Check Stage--------------------------------------------------------
---------------------------------------------------------------------
use Stage;

select* from stgHocSinh;
select* from stgLopHoc;
select* from stgMonHoc;
select* from stgDiem;

drop table stgMonHoc;
drop table stgDiem;
drop table stgLopHoc;
drop table stgHocSinh;
