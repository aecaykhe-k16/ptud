package ui;

import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.GridBagLayout;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import java.io.FileOutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.EnumSet;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.AbstractCellEditor;
import javax.swing.BorderFactory;
import javax.swing.ButtonModel;
import javax.swing.DefaultCellEditor;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.SwingConstants;
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellEditor;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumn;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import bus.IDatPhongService;
import bus.IDichVuService;
import bus.IHoaDonService;
import bus.IKhachHangService;
import bus.IPhongService;
import bus.implement.DatPhongImp;
import bus.implement.DichVuImp;
import bus.implement.HoaDonImp;
import bus.implement.KhachHangImp;
import bus.implement.PhongImp;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiThanhVien;
import entities.NhanVien;
import entities.Phong;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.SpecialButton;

public class PhongHoatDong extends JFrame implements ActionListener, MouseListener {
  private JButton btnBack, btnDV, btnNext, btnPre, btnThanhToan, btnCapNhatDV;
  private JLabel lblTenPhong, lblTenDV, lblGiaDV, lblSlDVName, lblGiaDVName, lblHinhAnh, lblDanhSachDV, lblSLDV;
  private JTextArea txaMaDV;
  private JPanel pnlDanhSachDV, pnlRight, pnlMain, pnlTamTinh;
  private JLayeredPane pnlMainUI;
  private Cursor handleCursor;
  private JTable tblDanhSachDV;
  private DefaultTableModel modelDanhSachDV;
  // thông tin phòng
  private JPanel pnlThongTinPhong;
  private JLabel lblLoaiPhong, lblSucChua, lblGioNhanPhong, lblGiaPhong;
  private JTextArea lblTenKhachHang, txtTenKhachHang;
  private JTextField txtLoaiPhong, txtSucChua, txtGioNhanPhong, txtGiaPhong;

  // In hóa đơn
  private JLabel lblTienPhong, lblTongTien;
  private JTextField txtTienPhong, txtTongTien;

  private JButton btnIn, btnDe;
  private JTextField txtNgayNhan, txtTienDV, txtThoiGianSuDung, txtNhanVien;
  private JLabel lblNgayNhan, lblTienDV, lblThoiGianSuDung, lblNhanVien;

  // service

  private IPhongService phongService = new PhongImp();
  private IHoaDonService hoaDonService = new HoaDonImp();
  private IDichVuService dichVuService = new DichVuImp();
  private IKhachHangService khachHangService = new KhachHangImp();
  private IDatPhongService datPhongService = new DatPhongImp();
  private LocalDateTime gioBatDau;
  private Phong phong = new Phong();
  private Generator generator = new Generator();
  private Date date;
  List<DichVu> listDV = dichVuService.dsDichVu();
  List<ChiTietDichVu> listCTDV = new ArrayList<ChiTietDichVu>();
  List<ChiTietHoaDon> listCTHD = new ArrayList<ChiTietHoaDon>();
  private String maHD = "";
  private double vourcher1 = 5, vourcher2, vourcher3 = 100000;

  private int index, checkCounter = 12;
  private KhachHang kh;
  private NhanVien nv;
  private HoaDon hoaDon;
  private String maPhong;

  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);

  public PhongHoatDong(String tenPhong, String maPhong,
      NhanVien nhanVien, KhachHang kh, String maHoaDon) throws MalformedURLException {

    this.kh = kh;
    nv = nhanVien;
    maHD = maHoaDon;
    this.maPhong = maPhong;
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    for (Phong p : phongService.dsPhong()) {
      if (p.getMaPhong().trim().equals(maPhong)) {
        phong = p;
        break;
      }
    }
    for (HoaDon hd : hoaDonService.dsHD()) {
      if (hd.getMaHD().trim().equals(maHD)) {
        hoaDon = hd;
        break;
      }
    }

    gioBatDau = hoaDon.getNgayLapHD();
    date = new Date();
    setTitle(Constants.TITLE);
    setSize(1100, 705);
    setLocationRelativeTo(null);
    setResizable(false);
    this.setIconImage(imageIcon);
    setLayout(null);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    pnlMain = new JPanel();
    pnlMain.setLayout(null);
    pnlMain.setBounds(0, 0, 1100, 705);
    pnlMain.setBackground(Color.WHITE);
    add(pnlMain);
    pnlMainUI = new JLayeredPane();
    pnlMainUI.setBackground(Color.WHITE);
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 1100, 705);

    lblTenPhong = new JLabel(tenPhong);
    lblTenPhong.setBounds(115, 8, 850, 50);
    lblTenPhong.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 30));
    lblTenPhong.setHorizontalAlignment(JLabel.CENTER);
    pnlMainUI.add(lblTenPhong);

    JPanel pnl = new JPanel() {
      @Override
      protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        int w = getWidth(), h = getHeight();
        Color color1 = Color.decode("#3fb5fb");
        Color color2 = Color.decode("#ee4062");
        GradientPaint gp = new GradientPaint(0, 0, color1, w, h, color2);
        g2d.setPaint(gp);
        g2d.fillRect(0, 0, w, h);
      }
    };
    pnl.setLayout(null);
    pnl.setBounds(0, 58, 1100, 3);
    pnlMainUI.add(pnl);

    btnBack = new JButton();
    btnBack.setBorder(null);
    btnBack.setBorderPainted(false);
    btnBack.setContentAreaFilled(false);
    btnBack.setFocusPainted(false);
    btnBack.setOpaque(false);
    btnBack.setCursor(handleCursor);

    pnlMainUI.add(btnBack);
    thongTinPhong();
    lblDanhSachDV = new JLabel("Danh sách dịch vụ:");
    lblDanhSachDV.setBounds(20, 220, 200, 16);
    lblDanhSachDV.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    pnlMainUI.add(lblDanhSachDV);
    uiRight();
    danhSachDV(index);

    btnPre = new MyButton(15, Color.decode("#ffffff"), Color.decode("#cccccc"));
    btnPre.setBorderPainted(false);
    btnPre.setFocusPainted(false);
    btnPre.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_LEFT, 20));
    btnPre.setBounds(20, 630, 100, 30);
    btnPre.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    btnPre.setCursor(handleCursor);
    btnPre.setEnabled(false);
    pnlMainUI.add(btnPre);

    btnNext = new MyButton(15, Color.decode("#ffffff"), Color.decode("#cccccc"));
    btnNext.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_RIGHT, 20));
    btnNext.setBorderPainted(false);
    btnNext.setFocusPainted(false);
    btnNext.setBounds(400, 630, 100, 30);
    btnNext.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    btnNext.setCursor(handleCursor);
    pnlMainUI.add(btnNext);

    btnThanhToan = new MyButton(15, Color.decode("#3A9E2F"), Color.decode("#ffffff"));
    btnThanhToan.setText("Thanh toán");
    btnThanhToan.setBounds(800, 630, 150, 30);
    btnThanhToan.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnThanhToan.setCursor(handleCursor);
    btnThanhToan.setBorder(null);
    btnThanhToan.setContentAreaFilled(false);
    btnThanhToan.setFocusPainted(false);
    btnThanhToan.setOpaque(false);
    pnlMainUI.add(btnThanhToan);

    btnCapNhatDV = new MyButton(15, Color.decode("#3A9E2F"), Color.decode("#ffffff"));
    btnCapNhatDV.setText("Cập nhật dịch vụ");
    btnCapNhatDV.setBounds(650, 630, 150, 30);
    btnCapNhatDV.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnCapNhatDV.setCursor(handleCursor);
    btnCapNhatDV.setBorder(null);
    btnCapNhatDV.setContentAreaFilled(false);
    btnCapNhatDV.setFocusPainted(false);
    btnCapNhatDV.setOpaque(false);
    pnlMainUI.add(btnCapNhatDV);

    pnlMain.add(pnlMainUI);
    btnBack.addActionListener(this);
    btnNext.addActionListener(this);
    btnPre.addActionListener(this);
    btnThanhToan.addActionListener(this);
    btnCapNhatDV.addActionListener(this);
    btnBack.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
        "btnBack");
    btnBack.getActionMap().put("btnBack", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnBack.doClick();
      }
    });
  }

  private void uiRight() {
    pnlTamTinh = new JPanel();
    TitledBorder titlTamTinh = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Tạm tính");
    pnlTamTinh.setBorder(titlTamTinh);
    pnlTamTinh.setLayout(null);
    pnlTamTinh.setBounds(510, 510, 568, 115);
    pnlTamTinh.setBackground(Color.WHITE);

    lblNgayNhan = new JLabel("Ngày nhận phòng: ");
    lblNgayNhan.setBounds(10, 20, 150, 20);
    lblNgayNhan.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblNgayNhan);
    txtNgayNhan = new JTextField(new SimpleDateFormat("dd/MM/yyyy").format(new Date()));
    txtNgayNhan.setBounds(145, 20, 160, 20);
    txtNgayNhan.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtNgayNhan.setBackground(Color.WHITE);
    txtNgayNhan.setBorder(null);
    txtNgayNhan.setFocusable(false);
    txtNgayNhan.setEditable(false);
    pnlTamTinh.add(txtNgayNhan);

    lblTienPhong = new JLabel("Tiền phòng: ");
    lblTienPhong.setBounds(10, 50, 150, 20);
    lblTienPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblTienPhong);
    txtTienPhong = new JTextField(String.valueOf(phong.getGiaPhong()).split("\\.")[0] + " VNĐ");
    txtTienPhong.setBounds(145, 50, 160, 20);
    txtTienPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtTienPhong.setBackground(Color.WHITE);
    txtTienPhong.setBorder(null);
    txtTienPhong.setFocusable(false);
    txtTienPhong.setEditable(false);
    pnlTamTinh.add(txtTienPhong);

    lblTienDV = new JLabel("Tiền dịch vụ: ");
    lblTienDV.setBounds(10, 80, 150, 20);
    lblTienDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblTienDV);
    txtTienDV = new JTextField();

    List<ChiTietDichVu> list = datPhongService.dsDichVuTheoTen(maPhong);
    long sum = 0;
    for (int index = 0; index < list.size(); index++) {
      sum += list.get(index).getSoLuong() * list.get(index).getDichVu().getGiaDichVu();
    }
    txtTienDV.setText(sum + " VNĐ");
    txtTienDV.setBounds(145, 80, 160, 20);
    txtTienDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtTienDV.setBackground(Color.WHITE);
    txtTienDV.setBorder(null);
    txtTienDV.setFocusable(false);
    txtTienDV.setEditable(false);
    pnlTamTinh.add(txtTienDV);

    lblNhanVien = new JLabel("Nhân viên: ");
    lblNhanVien.setBounds(320, 20, 150, 20);
    lblNhanVien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblNhanVien);
    txtNhanVien = new JTextField(nv.getTenNV());
    txtNhanVien.setBounds(400, 20, 165, 20);
    txtNhanVien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtNhanVien.setBackground(Color.WHITE);
    txtNhanVien.setBorder(null);
    txtNhanVien.setFocusable(false);
    txtNhanVien.setEditable(false);
    pnlTamTinh.add(txtNhanVien);

    lblThoiGianSuDung = new JLabel("Thời gian: ");
    lblThoiGianSuDung.setBounds(320, 50, 150, 20);
    lblThoiGianSuDung.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblThoiGianSuDung);
    txtThoiGianSuDung = new JTextField();
    LocalTime gioKetThuc = LocalTime.now();
    long gio = (gioKetThuc.getHour() + 3) - gioBatDau.getHour();
    long phut = (gioKetThuc.getMinute()) - gioBatDau.getMinute();
    if (phut < 0) {
      phut = 60 + phut;
      gio--;
    }
    txtThoiGianSuDung.setText(gio + " giờ " + phut + " phút");
    txtThoiGianSuDung.setBounds(400, 50, 165, 20);
    txtThoiGianSuDung.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtThoiGianSuDung.setBackground(Color.WHITE);
    txtThoiGianSuDung.setBorder(null);
    txtThoiGianSuDung.setFocusable(false);
    txtThoiGianSuDung.setEditable(false);
    pnlTamTinh.add(txtThoiGianSuDung);

    lblTongTien = new JLabel("Tổng tiền: ");
    lblTongTien.setBounds(320, 80, 150, 20);
    lblTongTien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlTamTinh.add(lblTongTien);
    double tongTien = (gio * phong.getGiaPhong() + phut * phong.getGiaPhong() / 60) + sum;
    txtTongTien = new JTextField(String.valueOf(tongTien).split("\\.")[0] + " VNĐ");
    txtTongTien.setBounds(400, 80, 165, 20);
    txtTongTien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    txtTongTien.setBackground(Color.WHITE);
    txtTongTien.setBorder(null);
    txtTongTien.setFocusable(false);
    txtTongTien.setEditable(false);
    pnlTamTinh.add(txtTongTien);
    pnlMainUI.add(pnlTamTinh);
    pnlRight = new JPanel();
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black),
        "Danh sách dịch vụ phòng đang sử dụng");
    pnlRight.setBorder(titlDanhSach);
    pnlRight.setLayout(null);
    pnlRight.setBounds(510, 62, 568, 450);
    pnlRight.setBackground(Color.WHITE);

    String[] header = { "STT", "Tên DV", "Đơn giá", "Số lượng", "Thành tiền", "Tăng/Giảm", "maDV" };
    modelDanhSachDV = new DefaultTableModel(header, 0);
    tblDanhSachDV = new JTable(modelDanhSachDV);
    TableColumn column = tblDanhSachDV.getColumnModel().getColumn(5);
    column.setCellRenderer(new ButtonsRenderer());
    column.setCellEditor(new ButtonsEditor(tblDanhSachDV, txtTienDV, txtTongTien, listDV, txtTienPhong));
    tblDanhSachDV.setRowHeight(20);
    tblDanhSachDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    tblDanhSachDV.getTableHeader().setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    tblDanhSachDV.getTableHeader().setPreferredSize(new Dimension(0, 20));
    tblDanhSachDV.getTableHeader().setReorderingAllowed(false);
    tblDanhSachDV.getTableHeader().setResizingAllowed(false);
    tblDanhSachDV.getColumnModel().getColumn(0).setMaxWidth(45);
    tblDanhSachDV.getColumnModel().getColumn(5).setMinWidth(83);
    tblDanhSachDV.getColumnModel().getColumn(5).setMaxWidth(150);
    tblDanhSachDV.getColumnModel().getColumn(6).setMinWidth(0);
    tblDanhSachDV.getColumnModel().getColumn(6).setMaxWidth(0);
    tblDanhSachDV.getColumnModel().getColumn(6).setWidth(0);
    tblDanhSachDV.addMouseListener(this);
    JScrollPane scrollPane = new JScrollPane(tblDanhSachDV);
    scrollPane.setBounds(10, 20, 550, 423);
    pnlRight.add(scrollPane);
    pnlMainUI.add(pnlRight);
    loadData();

  }

  private void thongTinPhong() {
    pnlThongTinPhong = new JPanel();
    pnlThongTinPhong.setLayout(null);
    pnlThongTinPhong.setBounds(5, 62, 500, 150);
    pnlThongTinPhong.setBackground(Color.white);
    TitledBorder title = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Thông tin phòng");
    pnlThongTinPhong.setBorder(title);
    pnlMainUI.add(pnlThongTinPhong);

    lblLoaiPhong = new JLabel("Loại phòng:");
    lblLoaiPhong.setBounds(20, 20, 140, 30);
    lblLoaiPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    pnlThongTinPhong.add(lblLoaiPhong);

    txtLoaiPhong = new JTextField(generator.convertLoaiPhongToString(phong.getLoaiPhong()));
    txtLoaiPhong.setBounds(160, 20, 120, 30);
    txtLoaiPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtLoaiPhong.setBackground(Color.white);
    txtLoaiPhong.setBorder(null);
    txtLoaiPhong.setEditable(false);
    pnlThongTinPhong.add(txtLoaiPhong);

    lblSucChua = new JLabel("Sức chứa:");
    lblSucChua.setBounds(20, 50, 140, 30);
    lblSucChua.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    pnlThongTinPhong.add(lblSucChua);

    txtSucChua = new JTextField("1 - " + phong.getSucChua() + " người");
    txtSucChua.setBounds(160, 50, 120, 30);
    txtSucChua.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtSucChua.setBackground(Color.white);
    txtSucChua.setBorder(null);
    txtSucChua.setEditable(false);
    pnlThongTinPhong.add(txtSucChua);

    lblGioNhanPhong = new JLabel("Giờ nhận phòng:");
    lblGioNhanPhong.setBounds(20, 80, 140, 30);
    lblGioNhanPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    pnlThongTinPhong.add(lblGioNhanPhong);

    String gioNhanPhong = "";

    if (gioBatDau.getHour() > 12) {
      if (gioBatDau.getMinute() < 10) {
        gioNhanPhong = (gioBatDau.getHour() - 12) + ":0" + gioBatDau.getMinute() + " PM";
      } else
        gioNhanPhong = (gioBatDau.getHour() - 12) + ":" + gioBatDau.getMinute() + " PM";
    } else {
      if (gioBatDau.getMinute() < 10) {
        gioNhanPhong = gioBatDau.getHour() + ":0" + gioBatDau.getMinute() + " AM";
      } else
        gioNhanPhong = gioBatDau.getHour() + ":" + gioBatDau.getMinute() + " AM";
    }
    txtGioNhanPhong = new JTextField(gioNhanPhong);

    txtGioNhanPhong.setBounds(160, 80, 120, 30);
    txtGioNhanPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtGioNhanPhong.setBackground(Color.white);
    txtGioNhanPhong.setBorder(null);
    txtGioNhanPhong.setEditable(false);
    pnlThongTinPhong.add(txtGioNhanPhong);

    lblGiaPhong = new JLabel("Giá phòng:");
    lblGiaPhong.setBounds(20, 110, 140, 30);
    lblGiaPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    pnlThongTinPhong.add(lblGiaPhong);

    txtGiaPhong = new JTextField(String.valueOf(phong.getGiaPhong()).split("\\.")[0] + " VNĐ");

    txtGiaPhong.setBounds(160, 110, 120, 30);
    txtGiaPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtGiaPhong.setBackground(Color.white);
    txtGiaPhong.setBorder(null);
    txtGiaPhong.setEditable(false);

    lblTenKhachHang = new JTextArea("Ưu đãi giảm giá khách hàng thành viên:");
    lblTenKhachHang.setLineWrap(true);
    lblTenKhachHang.setWrapStyleWord(true);
    lblTenKhachHang.setBackground(Color.white);
    lblTenKhachHang.setBorder(null);
    lblTenKhachHang.setEditable(false);
    lblTenKhachHang.setBounds(290, 20, 200, 50);
    lblTenKhachHang.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));

    txtTenKhachHang = new JTextArea();
    String txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
    String txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
    String txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
    if (kh != null) {
      if (kh.getLoaiTV().getUuDai() == 1) {
        txtTenKhachHang.setText(txt1);
      } else if (kh.getLoaiTV().getUuDai() == 2) {
        vourcher2 = 1;
        txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
        txtTenKhachHang.setText(txt1 + " + " + txt2);
      } else if (kh.getLoaiTV().getUuDai() == 3) {
        vourcher2 = 1;
        txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
        txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
        txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
        txtTenKhachHang.setText(txt1 + " +" + txt2 + " + " + txt3);
      } else if (kh.getLoaiTV().getUuDai() == 4) {
        vourcher2 = 1;
        vourcher3 = vourcher3 + 100000;
        txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
        txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
        txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
        txtTenKhachHang.setText(txt1 + " + " + txt2 + " + " + txt3);
      } else if (kh.getLoaiTV().getUuDai() == 5) {
        vourcher2 = 1;
        vourcher3 = vourcher3 + 400000;
        txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
        txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
        txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
        txtTenKhachHang.setText(txt1 + " + " + txt2 + " + " + txt3);
      }
    }
    txtTenKhachHang.setLineWrap(true);
    txtTenKhachHang.setWrapStyleWord(true);
    txtTenKhachHang.setBounds(290, 70, 180, 50);
    txtTenKhachHang.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
    txtTenKhachHang.setBackground(Color.white);
    txtTenKhachHang.setBorder(null);
    txtTenKhachHang.setEditable(false);
    if (kh != null && kh.getLoaiTV().getTenLoaiTV() != null) {
      pnlThongTinPhong.add(lblTenKhachHang);
      pnlThongTinPhong.add(txtTenKhachHang);
    }

    pnlThongTinPhong.add(txtGiaPhong);

  }

  private void danhSachDV(int index) {
    pnlDanhSachDV = new JPanel();
    int a = 0;
    int c = 0;
    int length = listDV.size();
    pnlDanhSachDV.setLayout(null);
    pnlDanhSachDV.setBounds(0, 240, 510, 390);
    pnlDanhSachDV.setBackground(Color.WHITE);
    Font font = new Font(Constants.MAIN_FONT, Font.PLAIN, 15);

    for (a = index; a < length; index++) {
      btnDV = new SpecialButton(10, null, Color.black);
      btnDV.setLayout(null);
      btnDV.setBorderPainted(false);
      btnDV.setFocusPainted(false);
      btnDV.setBounds(6 + (c % 4) * 125, 15 + (c / 4) * 125, 120, 120);
      btnDV.setCursor(new Cursor(Cursor.HAND_CURSOR));

      txaMaDV = new JTextArea(listDV.get(index).getMaDichVu());
      txaMaDV.setBounds(0, 0, 0, 0);
      txaMaDV.setEditable(false);
      txaMaDV.setVisible(false);
      btnDV.add(txaMaDV);

      lblHinhAnh = new JLabel();
      lblHinhAnh.setBounds(30, 0, 80, 65);
      lblHinhAnh.setIcon(new ImageIcon(
          new ImageIcon(listDV.get(index).getHinhAnh()).getImage().getScaledInstance(50, 50,
              Image.SCALE_SMOOTH)));
      btnDV.add(lblHinhAnh);

      lblTenDV = new JLabel(listDV.get(index).getTenDichVu().trim());
      lblTenDV.setBounds(15, 45, 100, 50);
      lblTenDV.setHorizontalAlignment(SwingConstants.CENTER);
      lblTenDV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 18));
      btnDV.add(lblTenDV);

      lblSlDVName = new JLabel("Số lượng:");
      lblSlDVName.setBounds(10, 58, 70, 60);
      lblSlDVName.setFont(font);
      btnDV.add(lblSlDVName);
      lblSLDV = new JLabel(listDV.get(index).getSlTon() + "");
      if (listDV.get(index).getSlTon() == 0) {
        lblSLDV.setForeground(Color.red);
        btnDV.setEnabled(false);
        btnDV.setBackground(Color.decode("#c7c7cb"));
      } else
        lblSLDV.setForeground(Color.black);
      lblSLDV.setBounds(80, 81, 30, 15);
      lblSLDV.setFont(font);
      btnDV.add(lblSLDV);

      lblGiaDVName = new JLabel("Giá:");
      lblGiaDVName.setBounds(10, 75, 70, 60);
      lblGiaDVName.setFont(font);
      btnDV.add(lblGiaDVName);
      lblGiaDV = new JLabel(listDV.get(index).getGiaDichVu() + "");
      lblGiaDV.setBounds(45, 75, 70, 60);
      lblGiaDV.setFont(font);
      btnDV.add(lblGiaDV);

      btnDV.addActionListener(this);
      pnlDanhSachDV.add(btnDV);
      c++;
      a++;

    }
    pnlMainUI.add(pnlDanhSachDV, 1);
    for (int i = 0; i < pnlDanhSachDV.getComponentCount(); i++) {
      if (pnlDanhSachDV.getComponent(i) instanceof JButton) {
        JButton btn = (JButton) pnlDanhSachDV.getComponent(i);
        for (int j = 0; j < btn.getComponentCount(); j++) {
          if (btn.getComponent(j) instanceof JTextArea) {
            JTextArea txa = (JTextArea) btn.getComponent(j);
            for (int k = 0; k < modelDanhSachDV.getRowCount(); k++) {
              if (txa.getText().equals(modelDanhSachDV.getValueAt(k, 6))) {
                btn.setEnabled(false);
                btn.setBackground(Color.decode("#c7c7cb"));
              }
            }
          }
        }
      }
    }
  }

  class ButtonIn extends DefaultCellEditor {
    private String label;

    public ButtonIn(JCheckBox checkBox) {
      super(checkBox);
    }

    public Component getTableCellEditorComponent(JTable table, Object value,
        boolean isSelected, int row, int column) {
      label = (value == null) ? "" : value.toString();
      btnIn.setText(label);
      btnIn.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
      btnIn.setBackground(Color.WHITE);
      btnIn.setBorderPainted(false);
      btnIn.setFocusPainted(false);
      return btnIn;
    }

    public Object getCellEditorValue() {
      return new String(label);
    }
  }

  class ButtonDe extends DefaultCellEditor {
    private String label;

    public ButtonDe(JCheckBox checkBox) {
      super(checkBox);
    }

    public Component getTableCellEditorComponent(JTable table, Object value,
        boolean isSelected, int row, int column) {
      label = (value == null) ? "" : value.toString();
      btnDe.setText(label);
      btnDe.setIcon(FontIcon.of(FontAwesomeSolid.MINUS, 20));
      btnDe.setBackground(Color.WHITE);
      btnDe.setBorderPainted(false);
      btnDe.setFocusPainted(false);
      return btnDe;
    }

    public Object getCellEditorValue() {
      return new String(label);
    }
  }

  public void exportFilePDF(String[][] info, String[][] purchase) {
    String defaultCurrentDirectoryPath = "G:\\New Folder\\";

    JFileChooser chooser = new JFileChooser(defaultCurrentDirectoryPath);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("PDF File", "pdf");
    chooser.setFileFilter(filter);
    chooser.setDialogTitle("Save as");
    chooser.setAcceptAllFileFilterUsed(false);

    if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
      Document document = new Document();
      document.setPageSize(PageSize.A5);
      document.setMargins(0, 0, 0, 0);
      com.itextpdf.text.Font fontPDF = null;
      com.itextpdf.text.Font fontBoldColor = null;
      com.itextpdf.text.Font fontBold = null;
      com.itextpdf.text.Font fontPDFSmall = null;
      com.itextpdf.text.Font fontPDFSmallItalic = null;
      try {

        FileOutputStream file = new FileOutputStream(chooser.getSelectedFile() + ".pdf");
        fontPDF = FontFactory.getFont("assets\\font\\vuArial.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 13);
        fontPDFSmall = FontFactory.getFont("assets\\font\\vuArial.ttf", BaseFont.IDENTITY_H,
            BaseFont.EMBEDDED,
            10);
        fontPDFSmallItalic = FontFactory.getFont("assets\\font\\vuArialItalic.ttf", BaseFont.IDENTITY_H,
            BaseFont.EMBEDDED,
            10);
        fontBold = FontFactory.getFont("assets\\font\\vuArialBold.ttf", BaseFont.IDENTITY_H,
            BaseFont.EMBEDDED,
            15);
        fontBoldColor = FontFactory.getFont("assets\\font\\vuArialBold.ttf",
            20, 0, BaseColor.RED);
        PdfWriter.getInstance(document, file);

        document.open();
        Paragraph tieuDe = new Paragraph(Constants.APP_NAME, fontBoldColor);
        tieuDe.setAlignment(Element.ALIGN_CENTER);
        tieuDe.setSpacingAfter(20);
        document.add(tieuDe);

        Chunk chunkDiaChi = new Chunk("525 Phan Văn Trị, phường 5, quận Gò Vấp, TP. Hồ Chí Minh",
            FontFactory.getFont("assets\\font\\vuArialItalic.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED, 15));
        chunkDiaChi.setTextRise(10);
        chunkDiaChi.setUnderline(0.1f, -(0.1f));
        chunkDiaChi.setAnchor("https://github.com/ptudCter/ptud");
        Paragraph diaChi = new Paragraph(chunkDiaChi);
        diaChi.setAlignment(Element.ALIGN_CENTER);
        diaChi.setSpacingAfter(5);
        document.add(diaChi);

        Paragraph hoaDonPara = new Paragraph(maHD + " | " + new SimpleDateFormat("dd/MM/yyyy").format(date),
            fontPDFSmallItalic);
        hoaDonPara.setIndentationLeft(220);
        document.add(hoaDonPara);

        Paragraph tenNV = new Paragraph(nv.getTenNV(), fontPDFSmallItalic);
        tenNV.setIndentationLeft(295);
        document.add(tenNV);

        Paragraph titleHD = new Paragraph("Hóa đơn thanh toán", fontBold);
        titleHD.setAlignment(Element.ALIGN_CENTER);
        titleHD.setSpacingAfter(3);
        document.add(titleHD);

        PdfPTable tableInfo = new PdfPTable(2);
        tableInfo.setWidths(new int[] { 3, 2 });

        tableInfo.setHorizontalAlignment(Element.ALIGN_CENTER);
        tableInfo.setWidthPercentage(80);

        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 2; j++) {
            PdfPCell cell = new PdfPCell(new Paragraph(info[i][j], fontPDF));
            cell.setFixedHeight(20);
            cell.setBorder(Rectangle.NO_BORDER);
            tableInfo.addCell(cell);
          }
        }
        tableInfo.setSpacingAfter(10);
        document.add(tableInfo);

        PdfPTable table = new PdfPTable(tblDanhSachDV.getColumnCount() - 2);
        table.setWidthPercentage(90); // set table width to 90%

        for (int i = 0; i < tblDanhSachDV.getColumnCount() - 2; i++) {

          PdfPCell cell = new PdfPCell(new Paragraph(tblDanhSachDV.getColumnName(i), fontPDFSmall));
          cell.setHorizontalAlignment(Element.ALIGN_CENTER);
          table.addCell(cell);
        }
        for (int rows = 0; rows < tblDanhSachDV.getRowCount(); rows++) {
          for (int cols = 0; cols < tblDanhSachDV.getColumnCount() - 2; cols++) {
            PdfPCell cell = new PdfPCell(new Paragraph(tblDanhSachDV.getModel().getValueAt(rows, cols).toString(),
                fontPDFSmall));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
          }
        }
        table.setSpacingAfter(10);
        if (tblDanhSachDV.getRowCount() > 0) {
          document.add(table);
        }

        PdfPTable sub = new PdfPTable(2);
        sub.setWidthPercentage(50);

        sub.setHorizontalAlignment(Element.ALIGN_RIGHT);
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 2; j++) {
            PdfPCell cell = new PdfPCell(new Paragraph(purchase[i][j], fontPDFSmall));
            cell.setBorder(Rectangle.NO_BORDER);

            sub.addCell(cell);
          }
        }
        sub.setSpacingAfter(10);
        document.add(sub);

        Paragraph underLine = new Paragraph("-------------------------------------------------------------------",
            fontPDFSmallItalic);
        underLine.setAlignment(Element.ALIGN_CENTER);
        underLine.setSpacingAfter(3);
        document.add(underLine);

        Paragraph camOn = new Paragraph("Cảm ơn quý khách và hẹn gặp lại", fontPDFSmallItalic);
        camOn.setAlignment(Element.ALIGN_CENTER);
        document.add(camOn);
        document.close();
        file.close();

        for (int index = 0; index < tblDanhSachDV.getRowCount(); index++) {
          for (DichVu dv : listDV) {
            if (dv.getMaDichVu().equals(tblDanhSachDV.getValueAt(index, 6).toString())) {
              DichVu dichVu = new DichVu(dv.getMaDichVu(), dv.getTenDichVu(),
                  dv.getGiaDichVu(),
                  dv.getSlTon() - Integer.parseInt(tblDanhSachDV.getValueAt(index,
                      3).toString()),
                  dv.getHinhAnh());
              dichVuService.suaDichVu(dichVu);
            }
          }
        }

        Desktop.getDesktop().open(new File(chooser.getSelectedFile() + ".pdf"));

      } catch (Exception e) {
        JOptionPane.showMessageDialog(null, "Xuất file thất bại");
        e.printStackTrace();
      }

    }

  }

  public void tinhTien() {
    double tongTien = 0;
    for (int i = 0; i < tblDanhSachDV.getRowCount(); i++) {
      tongTien += Double.parseDouble(tblDanhSachDV.getValueAt(i, 4).toString());
    }
    txtTienDV.setText(String.valueOf(tongTien).split("\\.")[0] + " VNĐ");
    double tongTienPhong = (Integer.parseInt(String.valueOf(tongTien).split("\\.")[0])
        + Integer.parseInt(txtGiaPhong.getText().split(" ")[0]));
    txtTongTien.setText(String.valueOf(tongTienPhong).split("\\.")[0] + " VNĐ");
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    for (int i = 0; i < pnlDanhSachDV.getComponentCount(); i++) {
      if (pnlDanhSachDV.getComponent(i) instanceof JButton) {
        JButton btn = (JButton) pnlDanhSachDV.getComponent(i);
        if (e.getSource() == btn) {
          for (int j = 0; j < btn.getComponentCount(); j++) {
            if (btn.getComponent(j) instanceof JTextArea) {
              JTextArea txt = (JTextArea) btn.getComponent(j);
              for (DichVu dv : listDV) {
                if (dv.getMaDichVu().equals(txt.getText())) {
                  modelDanhSachDV.addRow(
                      new Object[] {
                          modelDanhSachDV.getRowCount() + 1, dv.getTenDichVu().trim(), dv.getGiaDichVu(),
                          1 + "",
                          dv.getGiaDichVu(), EnumSet.allOf(Actions.class), dv.getMaDichVu() });
                  btn.setEnabled(false);
                  btn.setBackground(Color.decode("#c7c7cb"));
                  tinhTien();
                  break;
                }
              }
            }
          }
        }
      }
    }

    if (e.getSource() == btnNext) {
      if (checkCounter < listDV.size()) {
        index += 12;
        pnlDanhSachDV.removeAll();
        danhSachDV(index);
        checkCounter += 12;
        if (checkCounter >= listDV.size()) {
          btnNext.setEnabled(false);
        }
        btnPre.setEnabled(true);
      }
    } else if (e.getSource() == btnPre) {
      if (checkCounter > 12) {
        index -= 12;
        pnlDanhSachDV.removeAll();
        danhSachDV(index);
        checkCounter -= 12;
        if (checkCounter <= 12) {
          btnPre.setEnabled(false);
        }
        if (checkCounter < listDV.size()) {
          btnNext.setEnabled(true);
        }
      }
    }
    if (e.getSource() == btnBack)
      this.dispose();

    if (e.getSource() == btnThanhToan) {
      String uuDai = "không có";

      long gio = Long.parseLong(txtThoiGianSuDung.getText().split(" ")[0]);
      long phut = Long.parseLong(txtThoiGianSuDung.getText().split(" ")[2]);
      for (int i = 0; i < tblDanhSachDV.getRowCount(); i++) {
        DichVu dv = new DichVu();
        dv.setMaDichVu(tblDanhSachDV.getValueAt(i, 6).toString());
        dv.setTenDichVu(tblDanhSachDV.getValueAt(i, 1).toString());
        dv.setGiaDichVu(Double.parseDouble(tblDanhSachDV.getValueAt(i, 2).toString()));
        ChiTietDichVu ct = new ChiTietDichVu(Integer.parseInt(tblDanhSachDV.getValueAt(i, 3).toString()), dv);
        listCTDV.add(ct);
      }

      listCTHD.add(new ChiTietHoaDon((int) (gio * 60 + phut), phong));
      long tongTien = Long.parseLong(txtTongTien.getText().split(" ")[0]);
      String txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
      String txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
      String txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
      if (kh != null) {
        if (kh.getLoaiTV().getUuDai() == 1) {
          uuDai = (txt1);
        } else if (kh.getLoaiTV().getUuDai() == 2) {
          vourcher2 = 1;
          txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
          uuDai = (txt1 + " + " + txt2);
        } else if (kh.getLoaiTV().getUuDai() == 3) {
          vourcher2 = 1;
          txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
          txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
          txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
          uuDai = (txt1 + " + " + txt2 + " + " + txt3);
        } else if (kh.getLoaiTV().getUuDai() == 4) {
          vourcher2 = 1;
          vourcher3 = vourcher3 + 100000;
          txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
          txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
          txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
          uuDai = (txt1 + " + " + txt2 + " + " + txt3);
        } else if (kh.getLoaiTV().getUuDai() == 5) {
          vourcher2 = 1;
          vourcher3 = vourcher3 + 400000;
          txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
          txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
          txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
          uuDai = (txt1 + " + " + txt2 + " + " + txt3);
        }

      }
      if (kh != null) {
        try {
          if (tongTien >= 1500000 && tongTien < 5000000) {
            kh.setLoaiTV(new LoaiThanhVien("Bạc", 2));
            khachHangService.capNhatLoaiTV(kh);
          } else if (tongTien >= 5000000 && tongTien < 10000000) {
            kh.setLoaiTV(new LoaiThanhVien("Vàng", 3));
            khachHangService.capNhatLoaiTV(kh);
          } else if (tongTien >= 10000000 && tongTien < 15000000) {
            kh.setLoaiTV(new LoaiThanhVien("Bạch kim", 4));
            khachHangService.capNhatLoaiTV(kh);
          } else if (tongTien >= 15000000) {
            kh.setLoaiTV(new LoaiThanhVien("Kim cương", 5));
            khachHangService.capNhatLoaiTV(kh);
          }
        } catch (Exception e1) {
          e1.printStackTrace();
        }
      }

      String[][] info = new String[3][2];
      info[0][0] = "Giờ bắt đầu: ";
      info[0][1] = gioBatDau.getHour() + ":" + gioBatDau.getMinute() + " "
          + new SimpleDateFormat("dd/MM/yyyy").format(date);
      info[1][0] = "Thời gian sử dụng: ";
      info[1][1] = gio + " giờ " + phut + " phút";
      info[2][0] = "Tiền phòng: ";
      info[2][1] = String.format("%,d", (int) phong.getgiaPhong()) + " VNĐ";
      double uuDai1 = 0;
      double uuDai2 = 0;
      double uuDai3 = 0;
      for (String uu : uuDai.split("\\+")) {
        if (uu.contains("%")) {
          uuDai1 = Double.parseDouble(uu.split(" ")[0]);
        } else if (uu.contains("giờ")) {
          uuDai2 = Double.parseDouble(uu.split(" ")[1]);
        } else if (uu.contains("VNĐ")) {
          uuDai3 = Double.parseDouble(uu.split(" ")[1]);
        }
      }

      double tongTienThanhToan = tongTien - (tongTien * uuDai1 / 100) - (uuDai2 * phong.getgiaPhong()) - uuDai3;
      String[] tongTienformat = txtTongTien.getText().split(" ");
      String tienFormat1 = tongTienformat[0].replaceAll("\\B(?=(\\d{3})+(?!\\d))", ",");
      String tienFormat = String.format("%,d", (int) tongTienThanhToan);
      String[][] purchase = new String[3][2];
      purchase[0][0] = "Tổng tiền";
      purchase[0][1] = tienFormat1 + " VNĐ";
      purchase[1][0] = "Voucher";
      purchase[1][1] = uuDai;
      purchase[2][0] = "Tổng tiền thanh toán";
      purchase[2][1] = tienFormat + " VNĐ";
      int xemFile = JOptionPane.showConfirmDialog(null, "Thanh toán thành công. Bạn có muốn xem file không?",
          "Thông báo", JOptionPane.YES_NO_OPTION);
      hoaDonService.capNhatChiTietHoaDon(listCTHD.get(0).getThoiGianSuDung(), hoaDon.getMaHD());
      if (phong.getSoLanDatTruoc() > 0) {
        phongService.traPhong(phong.getMaPhong(), TrangThaiPhongEnum.DAT_TRUOC.name());
      } else {
        phongService.traPhong(phong.getMaPhong(), TrangThaiPhongEnum.TRONG.name());
      }
      if (xemFile == JOptionPane.YES_OPTION) {
        this.dispose();
        exportFilePDF(info, purchase);
      } else {
        this.dispose();
      }
    } else if (e.getSource() == btnCapNhatDV) {
      for (int i = 0; i < tblDanhSachDV.getRowCount(); i++) {
        if (Integer.parseInt(tblDanhSachDV.getValueAt(i, 3).toString()) > 0) {
          DichVu dv = new DichVu();
          dv.setMaDichVu(tblDanhSachDV.getValueAt(i, 6).toString());
          dv.setTenDichVu(tblDanhSachDV.getValueAt(i, 1).toString());
          dv.setGiaDichVu(Double.parseDouble(tblDanhSachDV.getValueAt(i, 2).toString()));
          ChiTietDichVu ct = new ChiTietDichVu(Integer.parseInt(tblDanhSachDV.getValueAt(i, 3).toString()), dv);
          listCTDV.add(ct);
        }
      }
      for (ChiTietDichVu ctdv : listCTDV) {
        hoaDonService.themChiTietDV(ctdv, hoaDon.getMaHD());
      }
      JOptionPane.showMessageDialog(null, "Cập nhật thành công");
    }
  }

  public void loadData() {
    List<ChiTietDichVu> list = datPhongService.dsDichVuTheoTen(maPhong);
    modelDanhSachDV.setRowCount(0);
    for (int index = 0; index < list.size(); index++) {
      modelDanhSachDV.addRow(
          new Object[] { index + 1, list.get(index).getDichVu().getTenDichVu(),
              list.get(index).getDichVu().getGiaDichVu(),
              list.get(index).getSoLuong(),
              list.get(index).getSoLuong() * list.get(index).getDichVu().getGiaDichVu(),
              EnumSet.allOf(Actions.class), list.get(index).getDichVu().getMaDichVu() });
    }

  }

  @Override
  public void mouseClicked(MouseEvent arg0) {

  }

  @Override
  public void mouseEntered(MouseEvent arg0) {
  }

  @Override
  public void mouseExited(MouseEvent arg0) {
  }

  @Override
  public void mousePressed(MouseEvent arg0) {
  }

  @Override
  public void mouseReleased(MouseEvent arg0) {
  }
}

class ButtonsEditor extends AbstractCellEditor implements TableCellEditor {
  private final ButtonsPanel panel = new ButtonsPanel();
  private final JTable table;
  private Object o;

  private class EditingStopHandler extends MouseAdapter implements ActionListener {
    @Override
    public void mousePressed(MouseEvent e) {
      Object o = e.getSource();
      if (o instanceof TableCellEditor) {
        actionPerformed(null);
      } else if (o instanceof JButton) {
        ButtonModel m = ((JButton) e.getComponent()).getModel();
        if (m.isPressed() && table.isRowSelected(table.getEditingRow()) && e.isControlDown()) {
          panel.setBackground(table.getBackground());
        }
      }
    }

    @Override
    public void actionPerformed(ActionEvent e) {

    }
  }

  public ButtonsEditor(JTable table, JTextField txtTienDV, JTextField txtTongTien, List<DichVu> listDV,
      JTextField txtTienPhong) {
    super();
    this.table = table;
    panel.buttons.get(0)
        .setAction(new Increment(table, txtTienDV, txtTongTien, listDV, txtTienPhong));
    panel.buttons.get(1)
        .setAction(new Decrement(table, txtTienDV, txtTongTien, txtTienPhong));

    EditingStopHandler handler = new EditingStopHandler();
    for (JButton b : panel.buttons) {
      b.addMouseListener(handler);
      b.addActionListener(handler);
    }
    panel.addMouseListener(handler);
  }

  @Override
  public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    panel.setBackground(table.getSelectionBackground());
    panel.updateButtons();
    o = value;
    return panel;
  }

  @Override
  public Object getCellEditorValue() {
    return o;
  }
}

class ButtonsPanel extends JPanel {
  public final List<JButton> buttons = new ArrayList<>();

  public ButtonsPanel() {
    super(new GridBagLayout());
    setOpaque(true);

    for (Actions action : Actions.values()) {
      JButton btn = new JButton(action.getAction());
      btn.setFocusable(false);
      btn.setRolloverEnabled(false);
      add(btn);
      buttons.add(btn);
    }
  }

  protected void updateButtons() {
    for (Actions action : Actions.values()) {
      if (action.equals(Actions.IN)) {
        JButton btn = buttons.get(0);
        btn.setText(Actions.IN.getAction());
        add(btn);
      } else {
        JButton btn = buttons.get(1);
        btn.setText(Actions.DE.getAction());
        add(btn);
      }
    }
  }
}

enum Actions {
  IN("+"), DE("-");

  private String action;

  private Actions(String action) {
    this.action = action;
  }

  public String getAction() {
    return action;
  }
}

class ButtonsRenderer implements TableCellRenderer {
  private final ButtonsPanel panel = new ButtonsPanel();

  @Override
  public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    panel.setBackground(isSelected ? table.getSelectionBackground() : table.getBackground());
    panel.updateButtons();
    return panel;
  }
}

class Decrement extends AbstractAction {
  private final JTable table;
  private JTextField txtTienDV, txtTongTien, txtTienPhong;

  public Decrement(JTable table, JTextField txtTienDV, JTextField txtTongTien, JTextField txtTienPhong) {
    super(Actions.DE.toString());
    this.table = table;
    this.txtTienDV = txtTienDV;
    this.txtTongTien = txtTongTien;
    this.txtTienPhong = txtTienPhong;
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    int row = table.getSelectedRow();
    if (Integer.parseInt(table.getValueAt(row, 3).toString()) == 0) {
      JOptionPane.showMessageDialog(null, "Số lượng không được nhỏ hơn 0", "Thông báo",
          JOptionPane.ERROR_MESSAGE);
    } else {
      table.setValueAt(Integer.parseInt(table.getValueAt(row, 3).toString()) - 1,
          row, 3);
      double donGia = Double.parseDouble(table.getValueAt(row, 2).toString());
      table.setValueAt(Integer.parseInt(table.getValueAt(row, 3).toString()) *
          donGia, row, 4);
      double tongTien = 0;
      for (int i = 0; i < table.getRowCount(); i++) {
        tongTien += Double.parseDouble(table.getValueAt(i, 4).toString());
      }
      txtTienDV.setText(String.valueOf(tongTien).split("\\.")[0] + " VNĐ");
      int tongTienPhong = Integer.parseInt(String.valueOf(tongTien).split("\\.")[0])
          + Integer.parseInt(txtTienPhong.getText().split(" ")[0]);
      txtTongTien.setText(tongTienPhong + " VNĐ");
      return;
    }
  }
}

class Increment extends AbstractAction {
  private final JTable table;
  private JTextField txtTienDV, txtTongTien, txtTienPhong;
  private List<DichVu> listDV;

  public Increment(JTable table, JTextField txtTienDV, JTextField txtTongTien, List<DichVu> listDV,
      JTextField txtTienPhong) {
    super(Actions.IN.toString());
    this.table = table;
    this.txtTienDV = txtTienDV;
    this.txtTongTien = txtTongTien;
    this.listDV = listDV;
    this.txtTienPhong = txtTienPhong;

  }

  @Override
  public void actionPerformed(ActionEvent e) {
    int row = table.convertRowIndexToModel(table.getEditingRow());

    int soLuong = Integer.parseInt(table.getValueAt(row, 3).toString());
    for (DichVu dv : listDV) {
      if (dv.getMaDichVu().equals(table.getValueAt(row, 6).toString())) {
        if (dv.getSlTon() < soLuong + 1) {
          JOptionPane.showMessageDialog(null, "Số lượng dịch vụ không đủ", "Thông báo",
              JOptionPane.ERROR_MESSAGE);
        } else {
          table.setValueAt(Integer.parseInt(table.getValueAt(row, 3).toString()) + 1, row, 3);
          double donGia = Double.parseDouble(table.getValueAt(row, 2).toString());
          table.setValueAt(Integer.parseInt(table.getValueAt(row, 3).toString()) * donGia, row, 4);
          double tongTien = 0;
          for (int i = 0; i < table.getRowCount(); i++) {
            tongTien += Double.parseDouble(table.getValueAt(i, 4).toString());
          }
          txtTienDV.setText(String.valueOf(tongTien).split("\\.")[0] + " VNĐ");
          int tongTienPhong = Integer.parseInt(String.valueOf(tongTien).split("\\.")[0])
              + Integer.parseInt(txtTienPhong.getText().split(" ")[0]);
          txtTongTien.setText(tongTienPhong + " VNĐ");
        }
      }
    }
  }
}
