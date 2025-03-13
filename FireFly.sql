CREATE DATABASE FireFly
GO
USE FireFly
GO
CREATE TABLE NhanVien (
    MaNhanVien NVARCHAR(20)PRIMARY KEY not null, -- Mã nhân viên 
    TenNhanVien NVARCHAR(50) NOT NULL, -- Tên nhân viên
    SoDienThoai NVARCHAR(20) UNIQUE NOT NULL, -- Số điện thoại
    Email NVARCHAR(100) UNIQUE, -- Email
    DiaChi NVARCHAR(200), -- Địa chỉ
    ChucVu BIT DEFAULT 0,
    Luong DECIMAL(10,2), -- Lương nhân viên
    NgayVaoLam DATE, -- Ngày bắt đầu làm việc
    MatKhau NVARCHAR(255) NOT NULL -- Mật khẩu đăng nhập
);
GO
CREATE TABLE KhachHang (
    MaKhachHang INT PRIMARY KEY IDENTITY(1,1) ,  -- Mã khách hàng tự động tăng
    HoTen NVARCHAR(100) NOT NULL,  -- Họ và tên khách hàng
    SoDienThoai NVARCHAR(20) UNIQUE NOT NULL,  -- Số điện thoại (không trùng)
    Email NVARCHAR(100) UNIQUE,  -- Email (có thể NULL, không trùng)
    DiaChi NVARCHAR(255),  -- Địa chỉ khách hàng
    NgaySinh DATE,  -- Ngày sinh khách hàng
    GioiTinh NVARCHAR(10),  -- Giới tính (chỉ nhận giá trị hợp lệ)
    NgayDangKy DATE DEFAULT GETDATE() -- Ngày đăng ký, mặc định là ngày hiện tại
);
GO
CREATE TABLE DanhMuc (
    MaDanhMuc NCHAR(10) PRIMARY KEY NOT NULL,  
    TenDanhMuc NVARCHAR(50) NOT NULL,
    MoTa NVARCHAR(255) NOT NULL
);
GO
CREATE TABLE SanPham (
    MaSanPham INT PRIMARY KEY IDENTITY(1,1), -- Mã sản phẩm (tự động tăng)
	MaDanhMuc NCHAR(10) NOT NULL, -- Mã danh mục sản phẩm
    TenSanPham NVARCHAR(50) NOT NULL, -- Tên sản phẩm
    MoTa NVARCHAR(255), -- Mô tả sản phẩm
    Gia DECIMAL(10,2) NOT NULL, -- Giá sản phẩm
    SoLuongTon INT NOT NULL DEFAULT 0, -- Số lượng tồn kho    
    HinhAnh NVARCHAR(255), -- Đường dẫn ảnh sản phẩm
    NgayTao DATE DEFAULT GETDATE(), -- Ngày thêm sản phẩm vào hệ thống
    FOREIGN KEY (MaDanhMuc) REFERENCES DanhMuc(MaDanhMuc) -- Liên kết với danh mục sản phẩm
);
GO

CREATE TABLE HoaDon (
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY,  -- Mã hóa đơn (tự động tăng)
    MaKhachHang INT NOT NULL,  -- Liên kết khách hàng
    NgayLap DATE NOT NULL DEFAULT GETDATE(),  -- Ngày lập hóa đơn
    TongTien DECIMAL(10,2) NOT NULL,  -- Tổng tiền hóa đơn
    PhuongThucThanhToan NVARCHAR(50) NOT NULL CHECK (PhuongThucThanhToan IN (N'Tiền mặt', N'Chuyển khoản', N'Thẻ tín dụng')), 
    TrangThai NVARCHAR(50) NOT NULL CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán')), 
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang),

);
GO
CREATE TABLE HoaDonChiTiet (
    MaHoaDonChiTiet INT IDENTITY(1,1) PRIMARY KEY,  -- Mã chi tiết hóa đơn (tự động tăng)
    MaHoaDon INT NOT NULL,  -- Liên kết hóa đơn
	MaNhanVien NVARCHAR(20) NOT NULL, -- Mã nhân viên phụ trách hóa đơn
    MaSanPham INT NOT NULL,  -- Liên kết sản phẩm
    SoLuong INT NOT NULL CHECK (SoLuong > 0),  -- Số lượng sản phẩm
    DonGia DECIMAL(10,2) NOT NULL,  -- Giá bán tại thời điểm mua
    ThanhTien AS (SoLuong * DonGia) PERSISTED,  -- Cột tính tổng tiền tự động
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),
    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham)
);
GO

--CREATE TABLE DonHang (
--    MaDonHang NCHAR(10) PRIMARY KEY NOT NULL, -- Mã đơn hàng
--	MaKhachHang INT,
--    MaNhanVien NVARCHAR(20) NOT NULL, -- Mã nhân viên phụ trách đơn hàng
--    TongTien DECIMAL(10,2) NOT NULL, -- Tổng tiền đơn hàng
--    TrangThai BIT DEFAULT 0, -- Trạng thái đơn hàng
--    NgayDatHang DATE DEFAULT GETDATE(), -- Ngày đặt hàng
--    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien), -- Liên kết với nhân viên tạo đơn hàn
--	FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
--);
--GO
--CREATE TABLE ChiTietDonHang (
--    MaChiTiet INT PRIMARY KEY IDENTITY(1,1), -- Mã chi tiết đơn hàng
--    MaDonHang NCHAR(10) NOT NULL, -- Mã đơn hàng
--    MaSanPham INT NOT NULL, -- Mã sản phẩm
--    SoLuong INT NOT NULL, -- Số lượng sản phẩm
--    GiaBan DECIMAL(10,2) NOT NULL, -- Giá sản phẩm tại thời điểm mua
--    FOREIGN KEY (MaDonHang) REFERENCES DonHang(MaDonHang), -- Liên kết với đơn hàng
--    FOREIGN KEY (MaSanPham) REFERENCES SanPham(MaSanPham) -- Liên kết với sản phẩm
--);
--GO
SELECT h.MaHoaDon, h.MaKhachHang, k.HoTen, c.MaSanPham, c.SoLuong, c.DonGia, c.ThanhTien
FROM HoaDonChiTiet c
JOIN HoaDon h ON c.MaHoaDon = h.MaHoaDon
JOIN KhachHang k ON h.MaKhachHang = k.MaKhachHang;
