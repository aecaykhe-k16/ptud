package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import entities.DatPhong;
import entities.DichVu;
import entities.KhachHang;
import entities.LoaiPhongEnum;
import entities.LoaiThanhVien;
import entities.NhanVien;
import entities.Phong;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;

public class DatPhongDao {
  public List<KhachHang> dsPhong() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<KhachHang> dsKhachHang = new ArrayList<KhachHang>();
    try {
      String sql = "SELECT * FROM KhachHang INNER JOIN"
          + "LoaiThanhVien ON KhachHang.maLoaiTV = LoaiThanhVien.maLoaiTV";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        LoaiThanhVien loaiThanhVien = new LoaiThanhVien(rs.getString("maLoaiTV"), rs.getString("tenLoaiTV"),
            rs.getInt("uuDai"), rs.getDate("ngayDangKy").toLocalDate(), rs.getDate("ngayHetHan").toLocalDate(),
            rs.getString("soDinhDanh"));
        KhachHang khachHang = new KhachHang(rs.getString("maKH"), rs.getString("tenKH"),
            rs.getString("sdt"), rs.getBoolean("gioiTinh"), rs.getString("diaChi"), rs.getBoolean("trangThai"));
        khachHang.setLoaiTV(loaiThanhVien);
        dsKhachHang.add(khachHang);

      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsKhachHang;
  }

  public List<DatPhong> dsPhongDat() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<DatPhong> dsPhongDat = new ArrayList<DatPhong>();
    try {
      String sql = "SELECT * FROM DatPhong INNER JOIN KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH INNER JOIN NhanVien ON DatPhong.maNhanVien = NhanVien.maNV INNER JOIN Phong ON DatPhong.maPhong = Phong.maPhong INNER JOIN LoaiThanhVien ON LoaiThanhVien.maKH = KhachHang.maKH";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        LoaiThanhVien loaiThanhVien = new LoaiThanhVien();
        loaiThanhVien.setMaLoaiTV(rs.getString("maLoaiTV"));
        KhachHang khachHang = new KhachHang(rs.getString("maKH"), rs.getString("tenKH"),
            rs.getString("sdt"), rs.getBoolean("gioiTinh"), rs.getString("diaChi"), rs.getBoolean("trangThai"));
        Phong phong = new Phong(
            rs.getString("maPhong"),
            rs.getString("tenPhong"),
            rs.getDouble("giaPhong"),
            rs.getInt("sucChua"),
            rs.getDouble("chieuRong"),
            rs.getDouble("chieuDai"),
            rs.getString("tivi"),
            rs.getString("ban"),
            rs.getString("tenSofa"),
            rs.getInt("slSofa"),
            rs.getInt("slLoa"),
            rs.getString("ttPhong").trim().equals("TRONG") ? TrangThaiPhongEnum.TRONG
                : rs.getString("ttPhong").trim().equals("HOAT_DONG") ? TrangThaiPhongEnum.HOAT_DONG
                    : TrangThaiPhongEnum.DAT_TRUOC,
            rs.getString("loaiPhong").trim().equals("VIP") ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG);
        NhanVien nv = new NhanVien(rs.getString("maNV"), rs.getString("tenNV"),
            rs.getString("sdt"), rs.getDate("ngaySinh").toLocalDate(), rs.getBoolean("gioiTinh"),
            rs.getDate("ngayTuyenDung").toLocalDate(),
            rs.getString("viTriCongViec"), rs.getString("diaChi"));
        DatPhong datPhong = new DatPhong(rs.getString("maDP"), rs.getDate("ngayDatPhong"),
            rs.getTimestamp("gioNhanPhong"));
        khachHang.setLoaiTV(loaiThanhVien);
        datPhong.setPhong(phong);
        datPhong.setNhanVien(nv);
        datPhong.setKhachHang(khachHang);
        dsPhongDat.add(datPhong);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsPhongDat;
  }

  public boolean xoaPhongDat(String maDP) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "DELETE FROM DatPhong WHERE maDP = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, maDP);
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;

  }

  public boolean datPhong(DatPhong datPhong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    Date ngayDatPhong = new Date(datPhong.getngayDatPhong().getTime());
    Timestamp gioNhanPhong = new Timestamp(datPhong.getGioNhanPhong().getTime());

    try {
      String sql = "INSERT INTO DatPhong VALUES(?,?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, datPhong.getMaDP());
      pst.setDate(2, ngayDatPhong);
      pst.setTimestamp(3, gioNhanPhong);
      pst.setString(4, datPhong.getNhanVien().getMaNV());
      pst.setString(5, datPhong.getKhachHang().getMaKH());
      pst.setString(6, datPhong.getPhong().getMaPhong());
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean suaPhong(DatPhong datPhong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    Date ngayDatPhong = new Date(datPhong.getngayDatPhong().getTime());
    Timestamp gioNhanPhong = new Timestamp(datPhong.getGioNhanPhong().getTime());
    try {
      String sql = "update DatPhong set ngayDatPhong = ?, gioNhanPhong = ?, maNhanVien = ?, maKhDatPhong = ?, maPhong = ? where maDP = ?";
      pst = con.prepareStatement(sql);
      pst.setDate(1, ngayDatPhong);
      pst.setTimestamp(2, gioNhanPhong);
      pst.setString(3, datPhong.getNhanVien().getMaNV());
      pst.setString(4, datPhong.getKhachHang().getMaKH());
      pst.setString(5, datPhong.getPhong().getMaPhong());
      pst.setString(6, datPhong.getMaDP());
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean chuyenPhong(String maPhongCu, String maPhongMoi) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "update ChiTietHoaDon set maPhong =? where maPhong =?";

      pst = con.prepareStatement(sql);

      pst.setString(1, maPhongMoi);
      pst.setString(2, maPhongCu);

      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean updatePhongCu(String maPhongCu, String ttCu) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql2 = "update Phong set ttPhong=?  where maPhong =?";
      pst = con.prepareStatement(sql2);
      pst.setString(1, ttCu);
      pst.setString(2, maPhongCu);

      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean updatePhongMoi(String maPhongMoi, String ttMoi) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {

      String sql3 = "update Phong set ttPhong=?  where maPhong =?";
      pst = con.prepareStatement(sql3);
      pst.setString(1, ttMoi);
      pst.setString(2, maPhongMoi);

      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public List<DichVu> dsDV() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    ResultSet rs = null;
    List<DichVu> dsDichVuTheoTen = new ArrayList<>();
    try {
      String sql = "SELECT * FROM DichVu";
      pst = con.prepareStatement(sql);
      rs = pst.executeQuery();
      while (rs.next()) {
        DichVu dichVu = new DichVu(rs.getString("maDichVu"), rs.getString("tenDichVu"),
            rs.getDouble("giaDichVu"), rs.getInt("slTon"), rs.getString("hinhAnh"));
        dsDichVuTheoTen.add(dichVu);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsDichVuTheoTen;
  }

}
