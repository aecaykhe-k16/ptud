package util;

import static util.Constants.TITLE;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import bus.IDatPhongService;
import bus.IKhachHangService;
import bus.INhanVienService;
import bus.IPhongService;
import bus.implement.DatPhongImp;
import entities.CaTruc;
import entities.ChiTietCaTruc;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiPhongEnum;
import entities.LoaiThanhVien;
import entities.Phong;
import entities.TrangThaiPhongEnum;

public class WorkingWithFile extends JFrame implements ActionListener {
  private JButton button;

  // In hóa đơn
  private JPanel pnlMainInHD;
  private JLabel lblTieuDe, lblDiaChiHD, lblHoaDon, lblTenNV, lblHoTenKH, lblSoGio, lblTienPhong,
      lblTongTien, lblVoucherHD, lblPhaiTra, lblCamOn;
  private JTextField txtMaHD, txtNgayLapHD, txtTenNV, txtTenKHHD, txtGio, txtTienPhong, txtTongTien, txtVoucher,
      txtPhaiTra;
  private JTable tblInHoaDon;
  private DefaultTableModel tblModelInHoaDon;
  private JButton btnInHoaDon, btnHuyInHoaDon;

  // service
  private IDatPhongService datPhongService = new DatPhongImp();
  JTable tblDichVu;
  DefaultTableModel tblModelDichVu;
  private JButton btnAdd, addToDB;
  private Generator generator = new Generator();
  private INhanVienService nhanVienService = new bus.implement.NhanVienImp();
  private IKhachHangService khachHangService = new bus.implement.KhachHangImp();
  private IPhongService phongService = new bus.implement.PhongImp();
  List<Phong> listPhong = new ArrayList<>();

  List<CaTruc> listCaTruc = new ArrayList<>();
  List<ChiTietCaTruc> listChiTietCaTruc = new ArrayList<>();
  List<HoaDon> listHoaDon = new ArrayList<>();

  public WorkingWithFile() {
    for (int i = 1; i <= 30; i++) {
      if (i % 2 == 0) {
        listPhong.add(new Phong(
            generator.tuTaoMaPhong("VIP"), "Phòng V" + generator.random3SoNguyen(),
            500000, 15, 25, 25,
            "Smart Tivi Samsung 4K 55 inch UA55AU7002",
            "Karaoke QVB 04",
            "Blizz 948SS", 7, 5,
            TrangThaiPhongEnum.TRONG, LoaiPhongEnum.VIP));
      } else {
        listPhong.add(new Phong(
            generator.tuTaoMaPhong("Thuong"), "Phòng T" + generator.random3SoNguyen(),
            200000, 10, 20, 20,
            "Android Tivi Toshiba",
            "Karaoke QVB 04",
            "Blizz 948SS", 5, 3,
            TrangThaiPhongEnum.TRONG, LoaiPhongEnum.THUONG));
      }
    }
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }

    setTitle(TITLE);
    setExtendedState(MAXIMIZED_BOTH);
    setMinimumSize(new Dimension(1500, 800));

    setDefaultCloseOperation(EXIT_ON_CLOSE);
    setLocationRelativeTo(null);
    this.setBackground(Color.WHITE);
    setLayout(null);
    btnAdd = new JButton("Thêm");
    btnAdd.setBounds(10, 10, 100, 50);
    add(btnAdd);
    btnAdd.addActionListener(this);

    addToDB = new JButton("Thêm vào DB");
    addToDB.setBounds(120, 10, 100, 50);
    add(addToDB);
    addToDB.addActionListener(this);

    String[] header = { "Mã", "tên", "Số điện thoại", "ngaysinh", "Giới Tính", "ngaytuyendung",
        "vitri",
        "Địa chỉ", "trangThai", "email" };
    // String[] header = { "Mã KH", "Họ Tên", "Số điện thoại", "Giới Tính ",
    // "Địa chỉ", "Loại thành viên", "Số định danh" };
    tblModelDichVu = new DefaultTableModel(header, 0);
    tblDichVu = new JTable(tblModelDichVu);
    tblDichVu.setRowHeight(30);
    JScrollPane scrollPane = new JScrollPane(tblDichVu);
    scrollPane.setBounds(50, 100, 1400, 700);
    add(scrollPane);

  }

  public static void main(String[] args) {
    new WorkingWithFile().setVisible(true);

  }

  public void importExcelToJtableJava() {
    File excelFile;
    FileInputStream excelFIS = null;
    BufferedInputStream excelBIS = null;
    XSSFWorkbook excelImportToJTable = null;
    String defaultCurrentDirectoryPath = "E:/kuga";
    JFileChooser excelFileChooser = new JFileChooser(defaultCurrentDirectoryPath);
    excelFileChooser.setDialogTitle("Select Excel File");
    FileNameExtensionFilter fnef = new FileNameExtensionFilter("EXCEL FILES", "xls", "xlsx", "xlsm");
    excelFileChooser.setFileFilter(fnef);
    int excelChooser = excelFileChooser.showOpenDialog(null);
    if (excelChooser == JFileChooser.APPROVE_OPTION) {
      try {
        excelFile = excelFileChooser.getSelectedFile();
        excelFIS = new FileInputStream(excelFile);
        excelBIS = new BufferedInputStream(excelFIS);
        excelImportToJTable = new XSSFWorkbook(excelBIS);
        XSSFSheet excelSheet = excelImportToJTable.getSheetAt(0);

        for (int row = 1; row <= excelSheet.getLastRowNum(); row++) {
          XSSFRow excelRow = excelSheet.getRow(row);

          XSSFCell hoten = excelRow.getCell(0);
          XSSFCell gioitinh = excelRow.getCell(1);
          XSSFCell diachi = excelRow.getCell(2);
          XSSFCell sdt = excelRow.getCell(3);
          XSSFCell dinhdanh = excelRow.getCell(4);
          XSSFCell ma = excelRow.getCell(5);

          tblModelDichVu.addRow(
              new Object[] { ma, hoten, sdt, gioitinh, diachi, "vip", dinhdanh });

          // XSSFCell ten = excelRow.getCell(0);
          // XSSFCell sdt = excelRow.getCell(8);
          // XSSFCell ngaysinh = excelRow.getCell(1);
          // XSSFCell gioitinh = excelRow.getCell(2);
          // XSSFCell ngaytuyendung = excelRow.getCell(5);
          // XSSFCell vitri = excelRow.getCell(6);
          // XSSFCell diachi = excelRow.getCell(3);
          // XSSFCell trangthai = excelRow.getCell(10);
          // XSSFCell ma = excelRow.getCell(8);
        }
        JOptionPane.showMessageDialog(null, "Imported Successfully !!.....");
      } catch (IOException iOException) {
        JOptionPane.showMessageDialog(null, iOException.getMessage());
      } finally {
        try {
          if (excelFIS != null) {
            excelFIS.close();
          }
          if (excelBIS != null) {
            excelBIS.close();
          }
          if (excelImportToJTable != null) {
            excelImportToJTable.close();
          }
        } catch (IOException iOException) {
          JOptionPane.showMessageDialog(null, iOException.getMessage());
        }
      }
    }

  }
  // create function export file excel

  @Override
  public void actionPerformed(ActionEvent arg0) {
    if (arg0.getSource() == btnAdd) {
      importExcelToJtableJava();
    }
    if (arg0.getSource() == addToDB) {
      for (int i = 0; i < tblDichVu.getRowCount(); i++) {
        String makh = tblDichVu.getValueAt(i, 0).toString();
        String hoten = tblDichVu.getValueAt(i, 1).toString();
        String sdt = tblDichVu.getValueAt(i, 2).toString();

        boolean gioitinh = tblDichVu.getValueAt(i, 3).toString().equals("Nam") ? true
            : false;

        String diachi = tblDichVu.getValueAt(i, 4).toString();
        String soDinhDanh = tblDichVu.getValueAt(i, 6).toString();
        String maloaitv = generator.tuTaoMaLoaiTV(soDinhDanh);
        int uudai = 1;
        String tenloaitv = "Thân Thiết";
        LocalDate ngaydangky = LocalDate.now();
        LocalDate ngayhethan = ngaydangky.plusYears(1);
        LoaiThanhVien ltVien = new LoaiThanhVien(maloaitv, tenloaitv, uudai,
            ngaydangky, ngayhethan, soDinhDanh);
        KhachHang khachHang = new KhachHang(makh, hoten, sdt, gioitinh, diachi, true);
        khachHang.setLoaiTV(ltVien);
        khachHangService.themKhachHang(khachHang);
      }

    }
  }

}
