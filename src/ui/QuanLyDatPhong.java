package ui;

import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Frame;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.DefaultCellEditor;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JComponent;
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
import javax.swing.Timer;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.github.lgooddatepicker.components.DatePicker;
import com.github.lgooddatepicker.components.DatePickerSettings;
import com.github.lgooddatepicker.optionalusertools.DateChangeListener;
import com.github.lgooddatepicker.zinternaltools.DateChangeEvent;

import bus.IDangNhapService;
import bus.IDatPhongService;
import bus.IHoaDonService;
import bus.IKhachHangService;
import bus.IPhanCongCaLamService;
import bus.IPhongService;
import bus.implement.DangNhapImp;
import bus.implement.DatPhongImp;
import bus.implement.HoaDonImp;
import bus.implement.KhachHangImp;
import bus.implement.PhanCongCaLamImp;
import bus.implement.PhongImp;
import dao.DatPhongDao;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DatPhong;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiPhongEnum;
import entities.NhanVien;
import entities.Phong;
import entities.TaiKhoan;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.SpecialButton;

public class QuanLyDatPhong extends JFrame implements ActionListener, MouseListener {

  private JLabel lblIconLogo, lblTitle, lblPhongList, lblDanhSachCaLam;
  private JPanel pnlMenu, pnlTop, pnInfo, pnlMain, pnlMainUI, pnlPhong,
      pnlSubDanhSachPhong;
  private JButton btnIconUser, btnIconLogout, btnDatPhong, btnChuyenPhong, btnSuaDatPhong, btnDatPhongNhanh, btnRefresh,
      btnMauHoatDong, btnMauTrong, btnMauDatTruoc, btnPhongList, btnPhongVIP, btnNext, btnPre, btnThanhToanNhanh;
  private JTextField txtHoatDong, txtTrong, txtDatTruoc;
  private JComboBox<String> cmbLoaiPhong, cmbPhong;
  private DefaultComboBoxModel<String> dfModelLoaiPhong, dfModelPhong;
  private JTable tblDichVu;
  private DefaultTableModel modelDichVu;

  private Cursor handleCursor;
  private JLayeredPane pnlDanhSachPhong, pnlCenterLeft;

  // phòng chờ
  private JPanel pnlPhongcho;
  private DefaultTableModel modelPhongCho;
  private JTable tblPhongCho;
  private JButton button;

  private JButton btnNhanVien, btnPhong, btnKhachHang, btnHoaDon, btnThongke, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnDichVu;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu, lblHoaDon;
  private JLayeredPane layeredPane;
  private boolean flagPhong = false;

  // đặt phòng
  private String maPhong, ngayDat;
  private JButton btnXacNhanDatPhong;
  private JLabel lblLoaiPhong, lblGioNhanPhong, lblngayDatPhong, lblSucChua, lblgiaPhong, lblTenKH, lblSdt, lblTV,
      lblDiaChi, lblGioiTinh;
  private JCheckBox chkGioiTinh;
  private JTextField txtgiaPhong, txtTenKH, txtSdt, txtLoaiTV, txtSucChua;
  private DatePicker ngayDatDatPhong;
  private JComboBox<String> cmbGioDat;
  private DefaultComboBoxModel<String> dfModelGioDat;
  private JTextArea txaDiachi;
  private JPanel pnlDatPhong;
  private DatePickerSettings dateSettings;
  private Font fontMain = new Font(Constants.MAIN_FONT, Font.PLAIN, 20);

  // sửa phòng
  private JButton btnXacNhanSuaPhong;
  private JPanel pnlSuaPhong;

  // chuyển phòng
  private String tenPhongCu;
  private JButton btnCfChuyenPhong;
  private JLabel lblPhongCanChuyen, lblLoaiPhongCanChuyen, lblGiaPhongCanChuyen,
      lblGiaPhongChuyenToi, lblGiaCP, lblSucChuaCanChuyen, lblSucChuaChuyenToi, lblSucChuaCP,
      lblKhachHangCanChuyen, lblKHCP;
  private JPanel pnlChuyenPhong;
  private String maPhongCu, maPhongMoi, loaiPhongcu, loaiPhongMoi;

  private JComboBox<String> cmbPhongCanChuyen, cmbPhongChuyenToi, cmbLoaiPhongCanChuyen, cmbLoaiPhongChuyenToi;
  private DefaultComboBoxModel<String> dfModelPhongCanChuyen, dfModelPhongChuyenToi, dfModelLoaiPhongCanChuyen,
      dfModelLoaiPhongChuyenToi;

  Font fontchu = new Font(Constants.MAIN_FONT, Font.BOLD, 20);

  // service
  private Generator generator = new Generator();
  private IDatPhongService datPhongService = new DatPhongImp();
  private IPhongService phongService = new PhongImp();
  private IKhachHangService khService = new KhachHangImp();
  private IHoaDonService hoaDonService = new HoaDonImp();
  private IDangNhapService dangNhap = new DangNhapImp();
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();
  private TaiKhoan tk;
  Font fontLb = new Font(Constants.MAIN_FONT, 0, 18);

  // entity
  private Phong phong;
  private KhachHang khachHang;
  private DatPhong datPhong;

  // constants
  private String HET_PHONG = "Hết phòng";
  private String maSuaDatPhong = "";
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);

  private int index = 0, checkCounter = 12;
  private List<Phong> listPhongThuong = datPhongService.dsPhongThuong();
  private boolean flag = true;
  private NhanVien nhanVien;

  public QuanLyDatPhong(TaiKhoan taiKhoan) throws MalformedURLException {

    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;
    nhanVien = dangNhap.getNV(tk.getEmail());
    pnlPhong = new JPanel();
    pnlPhong.setLayout(null);
    pnlPhong.setBackground(null);
    pnlPhong.setBounds(25, 20, 700, 100);

    this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    setExtendedState(MAXIMIZED_BOTH);
    this.setMinimumSize(new Dimension(1500, 800));
    this.setLocationRelativeTo(null);
    this.setLayout(null);
    this.setTitle("Phòng");
    this.setIconImage(imageIcon);
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 2000, 1500);
    add(layeredPane);

    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 2000, 1400);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    pnlTop();
    PnlMenu();
    PnlCenter();
    layeredPane.add(pnlMainUI, 1);
    // keybinding
    btnDatPhong.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnDatPhong");
    btnDatPhong.getActionMap().put("btnDatPhong", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnDatPhong.doClick();
      }
    });
    btnChuyenPhong.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F2, 0),
        "btnChuyenPhong");
    btnChuyenPhong.getActionMap().put("btnChuyenPhong", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnChuyenPhong.doClick();
      }
    });
    btnSuaDatPhong.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F3, 0),
        "btnSuaDatPhong");
    btnSuaDatPhong.getActionMap().put("btnSuaDatPhong", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnSuaDatPhong.doClick();
      }
    });
    btnDatPhongNhanh.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F4, 0),
        "btnDatPhongNhanh");
    btnDatPhongNhanh.getActionMap().put("btnDatPhongNhanh", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnDatPhongNhanh.doClick();
      }
    });
    btnRefresh.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F5, 0),
        "btnRefresh");
    btnRefresh.getActionMap().put("btnRefresh", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnRefresh.doClick();
      }
    });
    btnThanhToanNhanh.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0),
        "btnThanhToanNhanh");
    btnThanhToanNhanh.getActionMap().put("btnThanhToanNhanh", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnThanhToanNhanh.doClick();
      }
    });
    btnPhongVIP.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F7, 0),
        "btnPhongVIP");
    btnPhongVIP.getActionMap().put("btnPhongVIP", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnPhongVIP.doClick();
      }
    });
    btnMauHoatDong.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(
        KeyStroke.getKeyStroke(KeyEvent.VK_F8, 0),
        "btnMauHoatDong");
    btnMauHoatDong.getActionMap().put("btnMauHoatDong", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnMauHoatDong.doClick();
      }
    });
    btnMauTrong.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F9, 0),
        "btnMauTrong");
    btnMauTrong.getActionMap().put("btnMauTrong", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnMauTrong.doClick();
      }
    });
    btnMauDatTruoc.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F10, 0),
        "btnMauDatTruoc");
    btnMauDatTruoc.getActionMap().put("btnMauDatTruoc", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnMauDatTruoc.doClick();
      }
    });

  }

  private void pnlTop() {
    pnlTop = new JPanel();

    pnlTop.setBounds(0, 0, 2000, 100);

    pnlTop.setBackground(Color.decode(Constants.TITLE_COLOR));
    pnlTop.setLayout(null);

    lblIconLogo = new JLabel();
    lblIconLogo.setBounds(50, 0, 300, 100);
    lblIconLogo.setIcon(new ImageIcon(imageIcon));

    lblTitle = new JLabel(Constants.TITLE);
    lblTitle.setBounds(420, 0, 750, 100);
    lblTitle.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 80));
    lblTitle.setForeground(Color.white);

    pnInfo = new JPanel();
    pnInfo.setBounds(1300, 0, 250, 100);
    pnInfo.setBackground(Color.decode(Constants.TITLE_COLOR));
    pnInfo.setLayout(null);
    btnIconUser = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconUser.setText(nhanVien.getTenNV());
    btnIconUser.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 14));
    btnIconUser.setBounds(20, 0, 200, 50);
    btnIconUser.setBorder(null);
    btnIconUser.setBorderPainted(false);
    btnIconUser.setFocusPainted(false);
    btnIconUser.setCursor(handleCursor);
    btnIconUser.setBackground(Color.decode(Constants.TITLE_COLOR));
    btnIconUser.setIcon(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE));
    btnIconUser.setForeground(Color.white);

    btnIconLogout = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setText(Constants.DANG_XUAT);

    btnIconLogout.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 14));
    btnIconLogout.setBounds(20, 50, 200, 50);
    btnIconLogout.setBorder(null);
    btnIconLogout.setCursor(handleCursor);
    btnIconLogout.setBackground(Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setIcon(FontIcon.of(FontAwesomeSolid.SIGN_OUT_ALT, 30, Color.RED));
    btnIconLogout.setBorderPainted(false);
    btnIconLogout.setFocusPainted(false);
    btnIconLogout.setForeground(Color.white);

    lblDanhSachCaLam = new JLabel(caLamService.getCaTucTheoNV(tk.getEmail()));
    lblDanhSachCaLam.setBounds(1100, 70, 250, 20);
    if (caLamService.getCaTucTheoNV(tk.getEmail()).equals("Bạn không có ca trực trong ngày....")) {
      lblDanhSachCaLam.setBounds(1090, 70, 250, 20);
    }
    lblDanhSachCaLam.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    lblDanhSachCaLam.setForeground(Color.decode("#FFFFFFF"));
    Timer t = new Timer(500, this); // set a timer
    // set animation for timer
    t.setInitialDelay(0);
    t.start();
    pnlTop.add(lblDanhSachCaLam);

    pnInfo.add(btnIconUser);
    pnInfo.add(btnIconLogout);

    pnlTop.add(lblIconLogo);
    pnlTop.add(lblTitle);
    pnlTop.add(pnInfo);
    pnlMainUI.add(pnlTop);
    btnIconUser.addActionListener(this);
    btnIconLogout.addActionListener(this);
  }

  void PnlMenu() {
    try {
      URL lineURL = new URL(Constants.ICON_LINE);
      Image line = new ImageIcon(lineURL).getImage().getScaledInstance(10, 40, Image.SCALE_SMOOTH);
      pnlMenu = new JPanel();
      pnlMenu.setBounds(0, 100, 1800, 50);
      pnlMenu.setLayout(null);
      pnlMenu.setBackground(Color.decode(Constants.MAIN_COLOR));
      Font f2 = new Font(Constants.MAIN_FONT, 0, 20);

      lblNhanVien = new JLabel("");
      lblNhanVien.setBounds(168, 0, 10, 50);
      lblNhanVien.setIcon(new ImageIcon(line));

      btnNhanVien = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setText("Nhân viên");
      btnNhanVien.setFont(f2);
      btnNhanVien.setBounds(0, 0, 168, 50);
      btnNhanVien.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnNhanVien.setBorder(null);
      btnNhanVien.setCursor(handleCursor);
      btnNhanVien.setIcon(FontIcon.of(FontAwesomeSolid.USERS, 30));
      btnNhanVien.setFocusPainted(false);

      lblPhong = new JLabel("");
      lblPhong.setBounds(338, 0, 10, 50);
      lblPhong.setIcon(new ImageIcon(line));

      btnPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnPhong.setText("Phòng");
      btnPhong.setFont(f2);
      btnPhong.setBounds(170, 0, 168, 50);
      btnPhong.setBorder(null);
      btnPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhong.setCursor(handleCursor);
      btnPhong.setIcon(FontIcon.of(FontAwesomeSolid.DOOR_CLOSED, 30));
      btnPhong.setFocusPainted(false);

      lblKhachHang = new JLabel("");
      lblKhachHang.setBounds(508, 0, 10, 50);
      lblKhachHang.setIcon(new ImageIcon(line));

      btnKhachHang = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setText("Khách hàng");
      btnKhachHang.setFont(f2);
      btnKhachHang.setBounds(340, 0, 168, 50);
      btnKhachHang.setBorder(null);
      btnKhachHang.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnKhachHang.setCursor(handleCursor);
      btnKhachHang.setIcon(FontIcon.of(FontAwesomeSolid.USER_TIE, 30));
      btnKhachHang.setFocusPainted(false);

      lblHoaDon = new JLabel("");
      lblHoaDon.setBounds(678, 0, 10, 50);
      lblHoaDon.setIcon(new ImageIcon(line));

      btnHoaDon = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setText("Hóa đơn");
      btnHoaDon.setFont(f2);
      btnHoaDon.setBounds(510, 0, 168, 50);
      btnHoaDon.setBorder(null);
      btnHoaDon.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnHoaDon.setCursor(handleCursor);
      btnHoaDon.setIcon(FontIcon.of(FontAwesomeSolid.RECEIPT, 30));
      btnHoaDon.setFocusPainted(false);

      lblThongke = new JLabel("");
      lblThongke.setBounds(848, 0, 10, 50);
      lblThongke.setIcon(new ImageIcon(line));

      btnThongke = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnThongke.setText("Thống kê");
      btnThongke.setFont(f2);
      btnThongke.setBounds(680, 0, 168, 50);
      btnThongke.setBorder(null);
      btnThongke.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnThongke.setCursor(handleCursor);
      btnThongke.setIcon(FontIcon.of(FontAwesomeSolid.CHART_BAR, 30));
      btnThongke.setFocusPainted(false);

      lblPhanCong = new JLabel("");
      lblPhanCong.setBounds(1018, 0, 10, 50);
      lblPhanCong.setIcon(new ImageIcon(line));

      btnPhanCong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnPhanCong.setText("Phân công");
      btnPhanCong.setFont(f2);
      btnPhanCong.setBounds(850, 0, 168, 50);
      btnPhanCong.setBorder(null);
      btnPhanCong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnPhanCong.setCursor(handleCursor);
      btnPhanCong.setIcon(FontIcon.of(FontAwesomeSolid.TASKS, 30));
      btnPhanCong.setFocusPainted(false);

      lblQuanLyDatPhong = new JLabel("");
      lblQuanLyDatPhong.setBounds(1188, 0, 10, 50);
      lblQuanLyDatPhong.setIcon(new ImageIcon(line));

      btnQuanLyDatPhong = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnQuanLyDatPhong.setText("Đặt phòng");
      btnQuanLyDatPhong.setFont(f2);
      btnQuanLyDatPhong.setBounds(1020, 0, 168, 50);
      btnQuanLyDatPhong.setBorder(null);
      btnQuanLyDatPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnQuanLyDatPhong.setCursor(handleCursor);
      btnQuanLyDatPhong.setIcon(FontIcon.of(FontAwesomeSolid.TH, 30, Color.decode("#7743DB")));
      btnQuanLyDatPhong.setFocusPainted(false);

      lblDichVu = new JLabel("");
      lblDichVu.setBounds(1358, 0, 10, 50);
      lblDichVu.setIcon(new ImageIcon(line));

      btnDichVu = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnDichVu.setText("Dịch vụ");
      btnDichVu.setFont(f2);
      btnDichVu.setBounds(1190, 0, 168, 50);
      btnDichVu.setBorder(null);
      btnDichVu.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnDichVu.setCursor(handleCursor);
      btnDichVu.setIcon(FontIcon.of(FontAwesomeSolid.CONCIERGE_BELL, 30));
      btnDichVu.setFocusPainted(false);

      btnTroGiup = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setText("Trợ giúp");
      btnTroGiup.setFont(f2);
      btnTroGiup.setBounds(1360, 0, 180, 50);
      btnTroGiup.setBorder(null);
      btnTroGiup.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setCursor(handleCursor);
      btnTroGiup.setIcon(FontIcon.of(FontAwesomeSolid.QUESTION_CIRCLE, 30));
      btnTroGiup.setFocusPainted(false);
    } catch (Exception e) {
      e.printStackTrace();
    }
    if (nhanVien.getQuanLy() == null) {
      lblKhachHang.setBounds(168, 0, 10, 50);
      btnKhachHang.setBounds(0, 0, 168, 50);
      lblHoaDon.setBounds(338, 0, 10, 50);
      btnHoaDon.setBounds(170, 0, 168, 50);
      lblThongke.setBounds(508, 0, 10, 50);
      btnThongke.setBounds(340, 0, 168, 50);
      lblQuanLyDatPhong.setBounds(678, 0, 10, 50);
      btnQuanLyDatPhong.setBounds(510, 0, 168, 50);
      lblDichVu.setBounds(848, 0, 10, 50);
      btnDichVu.setBounds(680, 0, 168, 50);
      btnTroGiup.setBounds(850, 0, 180, 50);
      pnlMenu.add(lblKhachHang);
      pnlMenu.add(btnKhachHang);
      pnlMenu.add(lblHoaDon);
      pnlMenu.add(btnHoaDon);
      pnlMenu.add(lblThongke);
      pnlMenu.add(btnThongke);

      pnlMenu.add(lblQuanLyDatPhong);
      pnlMenu.add(btnQuanLyDatPhong);
      pnlMenu.add(lblDichVu);
      pnlMenu.add(btnDichVu);
      pnlMenu.add(btnTroGiup);
      btnKhachHang.addActionListener(this);
      btnHoaDon.addActionListener(this);
      btnThongke.addActionListener(this);
      btnQuanLyDatPhong.addActionListener(this);
      btnDichVu.addActionListener(this);
      btnTroGiup.addActionListener(this);
    } else {
      pnlMenu.add(lblNhanVien);
      pnlMenu.add(btnNhanVien);
      pnlMenu.add(lblPhong);
      pnlMenu.add(btnPhong);
      pnlMenu.add(lblKhachHang);
      pnlMenu.add(btnKhachHang);
      pnlMenu.add(lblHoaDon);
      pnlMenu.add(btnHoaDon);
      pnlMenu.add(lblThongke);
      pnlMenu.add(btnThongke);
      pnlMenu.add(lblPhanCong);
      pnlMenu.add(btnPhanCong);
      pnlMenu.add(lblQuanLyDatPhong);
      pnlMenu.add(btnQuanLyDatPhong);
      pnlMenu.add(lblDichVu);
      pnlMenu.add(btnDichVu);
      pnlMenu.add(btnTroGiup);
      btnNhanVien.addActionListener(this);
      btnPhong.addActionListener(this);
      btnKhachHang.addActionListener(this);
      btnHoaDon.addActionListener(this);
      btnThongke.addActionListener(this);
      btnPhanCong.addActionListener(this);
      btnQuanLyDatPhong.addActionListener(this);
      btnDichVu.addActionListener(this);
      btnTroGiup.addActionListener(this);
    }
    pnlMainUI.add(pnlMenu);

  }

  private void PnlCenter() {

    pnlMain = new JPanel();
    pnlMain.setBounds(0, 160, 1800, 800);
    pnlMain.setLayout(null);
    pnlMain.setBackground(Color.decode(Constants.MAIN_COLOR));

    pnlDanhSachPhong = new JLayeredPane();
    pnlDanhSachPhong.setBounds(780, 0, 740, 620);
    pnlDanhSachPhong.setLayout(null);
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Danh sách phòng:");
    pnlDanhSachPhong.setBorder(titlDanhSach);

    btnPhongVIP = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnPhongVIP.setBorderPainted(false);
    btnPhongVIP.setFocusPainted(false);
    btnPhongVIP.setText("Phòng VIP (F7)");
    btnPhongVIP.setBounds(500, 20, 200, 40);
    btnPhongVIP.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnPhongVIP.setFont(fontLb);
    btnPhongVIP.setCursor(handleCursor);

    btnThanhToanNhanh = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR),
        Color.decode(Constants.BTN_MAIN_COLOR));
    btnThanhToanNhanh.setBorderPainted(false);
    btnThanhToanNhanh.setFocusPainted(false);
    btnThanhToanNhanh.setText("Thanh toán nhanh (F6)");
    btnThanhToanNhanh.setBounds(250, 20, 230, 40);
    btnThanhToanNhanh.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnThanhToanNhanh.setFont(fontLb);
    btnThanhToanNhanh.setCursor(handleCursor);

    btnRefresh = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnRefresh.setText("Làm mới(F5)");
    btnRefresh.setBorderPainted(false);
    btnRefresh.setFocusPainted(false);
    btnRefresh.setBounds(50, 20, 160, 40);
    btnRefresh.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnRefresh.setFont(fontLb);
    btnRefresh.setCursor(handleCursor);

    btnPre = new MyButton(15, Color.decode("#cccccc"), Color.decode("#cccccc"));
    btnPre.setBorderPainted(false);
    btnPre.setFocusPainted(false);
    btnPre.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_LEFT, 20));
    btnPre.setBounds(260, 530, 50, 30);
    btnPre.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    btnPre.setCursor(handleCursor);

    btnNext = new MyButton(15, Color.decode("#cccccc"), Color.decode("#cccccc"));
    btnNext.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_RIGHT, 20));
    btnNext.setBorderPainted(false);
    btnNext.setFocusPainted(false);
    btnNext.setBounds(410, 530, 50, 30);
    btnNext.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    btnNext.setCursor(handleCursor);

    btnMauHoatDong = new JButton("Phòng hoạt động (F8)");
    btnMauHoatDong.setBounds(70, 590, 190, 20);
    btnMauHoatDong.setBorderPainted(false);
    btnMauHoatDong.setContentAreaFilled(false);
    btnMauHoatDong.setFocusPainted(false);
    btnMauHoatDong.setOpaque(false);
    btnMauHoatDong.setCursor(handleCursor);

    txtHoatDong = new JTextField();
    txtHoatDong.setBounds(60, 590, 40, 20);
    txtHoatDong.setEditable(false);
    txtHoatDong.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
    txtHoatDong.setBorder(null);

    btnMauTrong = new JButton("Phòng trống (F9)");
    btnMauTrong.setBounds(290, 590, 170, 20);
    btnMauTrong.setBorderPainted(false);
    btnMauTrong.setContentAreaFilled(false);
    btnMauTrong.setFocusPainted(false);
    btnMauTrong.setOpaque(false);
    btnMauTrong.setCursor(handleCursor);

    txtTrong = new JTextField();
    txtTrong.setBounds(280, 590, 40, 20);
    txtTrong.setEditable(false);
    txtTrong.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
    txtTrong.setBorder(null);

    btnMauDatTruoc = new JButton("Phòng đặt trước (F10)");
    btnMauDatTruoc.setBounds(500, 590, 190, 20);
    btnMauDatTruoc.setBorderPainted(false);
    btnMauDatTruoc.setContentAreaFilled(false);
    btnMauDatTruoc.setFocusPainted(false);
    btnMauDatTruoc.setOpaque(false);
    btnMauDatTruoc.setCursor(handleCursor);

    txtDatTruoc = new JTextField();
    txtDatTruoc.setBounds(490, 590, 40, 20);
    txtDatTruoc.setBackground(Color.decode(Constants.MENU_TITLE_COLOR));
    txtDatTruoc.setEditable(false);
    txtDatTruoc.setBorder(null);

    pnlDanhSachPhong.add(btnMauHoatDong);
    pnlDanhSachPhong.add(txtHoatDong);
    pnlDanhSachPhong.add(btnMauTrong);
    pnlDanhSachPhong.add(txtTrong);
    pnlDanhSachPhong.add(btnMauDatTruoc);
    pnlDanhSachPhong.add(txtDatTruoc);
    pnlDanhSachPhong.add(btnPhongVIP);
    pnlDanhSachPhong.add(btnThanhToanNhanh);
    pnlDanhSachPhong.add(btnRefresh);
    pnlDanhSachPhong.add(btnPre);
    pnlDanhSachPhong.add(btnNext);

    btnPre.setEnabled(false);
    danhSachPhong(listPhongThuong, index);
    PnlCenterLeft();

    pnlMain.add(pnlDanhSachPhong);

    pnlMainUI.add(pnlMain);

    btnPhongVIP.addActionListener(this);
    btnThanhToanNhanh.addActionListener(this);
    btnRefresh.addActionListener(this);
    btnMauDatTruoc.addActionListener(this);
    btnMauHoatDong.addActionListener(this);
    btnMauTrong.addActionListener(this);
    btnPre.addActionListener(this);
    btnNext.addActionListener(this);

  }

  private void PnlCenterLeft() {
    pnlCenterLeft = new JLayeredPane();
    pnlCenterLeft.setBounds(0, 0, 780, 860);
    pnlCenterLeft.setLayout(null);
    pnlCenterLeft.setBackground(Color.decode(Constants.MAIN_COLOR));

    btnDatPhong = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnDatPhong.setBorderPainted(false);
    btnDatPhong.setFocusPainted(false);
    btnDatPhong.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnDatPhong.setText("Đặt phòng (F1)");
    btnDatPhong.setBounds(10, 10, 160, 40);
    btnDatPhong.setFont(fontLb);

    btnDatPhong.setCursor(handleCursor);

    btnChuyenPhong = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnChuyenPhong.setBorderPainted(false);
    btnChuyenPhong.setFocusPainted(false);
    btnChuyenPhong.setText("Chuyển phòng (F2)");
    btnChuyenPhong.setBounds(180, 10, 190, 40);
    btnChuyenPhong.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnChuyenPhong.setFont(fontLb);
    btnChuyenPhong.setCursor(handleCursor);

    btnSuaDatPhong = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnSuaDatPhong.setBorderPainted(false);
    btnSuaDatPhong.setFocusPainted(false);
    btnSuaDatPhong.setText("Sửa đặt phòng (F3)");
    btnSuaDatPhong.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnSuaDatPhong.setBounds(380, 10, 200, 40);
    btnSuaDatPhong.setFont(fontLb);
    btnSuaDatPhong.setCursor(handleCursor);

    btnDatPhongNhanh = new MyButton(30, Color.decode(Constants.BTN_MAIN_COLOR), Color.decode(Constants.BTN_MAIN_COLOR));
    btnDatPhongNhanh.setBorderPainted(false);
    btnDatPhongNhanh.setFocusPainted(false);
    btnDatPhongNhanh.setText("Đặt nhanh (F4)");
    btnDatPhongNhanh.setForeground(Color.decode(Constants.MAIN_TEXT_COLOR));
    btnDatPhongNhanh.setBounds(590, 10, 160, 40);
    btnDatPhongNhanh.setFont(fontLb);
    btnDatPhongNhanh.setCursor(handleCursor);

    pnlCenterLeft.add(btnDatPhong);
    pnlCenterLeft.add(btnChuyenPhong);
    pnlCenterLeft.add(btnSuaDatPhong);
    pnlCenterLeft.add(btnDatPhongNhanh);

    btnDatPhong.addActionListener(this);
    btnChuyenPhong.addActionListener(this);
    btnSuaDatPhong.addActionListener(this);
    btnDatPhongNhanh.addActionListener(this);
    pnlMain.add(pnlCenterLeft);
    DatPhong();
    DsPhongCho();
  }

  public void DatPhong() {
    pnlDatPhong = new JPanel();
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Đặt phòng");
    pnlDatPhong.setBorder(titlDanhSach);
    pnlDatPhong.setLayout(null);
    pnlDatPhong.setBounds(10, 60, 750, 360);
    pnlDatPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
    UiDatPhong();
    UiKhach();
    btnXacNhanDatPhong = new MyButton(30, Color.decode(Constants.BTN_CONFIRM_COLOR),
        Color.decode(Constants.BTN_CONFIRM_COLOR));
    btnXacNhanDatPhong.setBorderPainted(false);
    btnXacNhanDatPhong.setFocusPainted(false);
    btnXacNhanDatPhong.setText("Đặt phòng");
    btnXacNhanDatPhong.setBounds(300, 320, 170, 30);

    btnXacNhanDatPhong.setFont(fontMain);
    btnXacNhanDatPhong.setCursor(handleCursor);

    pnlDatPhong.add(btnXacNhanDatPhong);

    btnXacNhanDatPhong.addActionListener(this);
    pnlCenterLeft.add(pnlDatPhong, 1);

  }

  public void SuaPhong() {
    pnlSuaPhong = new JPanel();
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Sửa phòng đặt");
    pnlSuaPhong.setBorder(titlDanhSach);
    pnlSuaPhong.setLayout(null);
    pnlSuaPhong.setBounds(10, 60, 750, 360);
    pnlSuaPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
    UISuaPhong();
    UiSuaKhach();
    btnXacNhanSuaPhong = new MyButton(30, Color.decode(Constants.BTN_CONFIRM_COLOR),
        Color.decode(Constants.BTN_CONFIRM_COLOR));
    btnXacNhanSuaPhong.setBorderPainted(false);
    btnXacNhanSuaPhong.setFocusPainted(false);
    btnXacNhanSuaPhong.setText("Sửa phòng");
    btnXacNhanSuaPhong.setBounds(300, 320, 170, 30);

    btnXacNhanSuaPhong.setFont(fontMain);
    btnXacNhanSuaPhong.setCursor(handleCursor);

    pnlSuaPhong.add(btnXacNhanSuaPhong);

    btnXacNhanSuaPhong.addActionListener(this);
    pnlCenterLeft.add(pnlSuaPhong);
  }

  public void ChuyenPhong() {
    pnlChuyenPhong = new JPanel();
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Chuyển phòng");
    pnlChuyenPhong.setBorder(titlDanhSach);
    pnlChuyenPhong.setLayout(null);
    pnlChuyenPhong.setBounds(10, 60, 750, 360);
    pnlChuyenPhong.setBackground(Color.decode(Constants.MAIN_COLOR));

    lblLoaiPhongCanChuyen = new JLabel("Loại phòng ");
    lblLoaiPhongCanChuyen.setBounds(20, 20, 150, 30);
    lblLoaiPhongCanChuyen.setFont(fontMain);
    pnlChuyenPhong.add(lblLoaiPhongCanChuyen);

    lblPhongCanChuyen = new JLabel("Tên phòng");
    lblPhongCanChuyen.setBounds(20, 50, 150, 30);
    lblPhongCanChuyen.setFont(fontMain);
    pnlChuyenPhong.add(lblPhongCanChuyen);

    lblGiaCP = new JLabel("Giá");
    lblGiaCP.setBounds(20, 80, 150, 30);
    lblGiaCP.setFont(fontMain);
    pnlChuyenPhong.add(lblGiaCP);

    lblSucChuaCP = new JLabel("Sức chứa");
    lblSucChuaCP.setBounds(20, 110, 150, 30);
    lblSucChuaCP.setFont(fontMain);
    pnlChuyenPhong.add(lblSucChuaCP);

    lblKHCP = new JLabel("Khách hàng");
    lblKHCP.setBounds(20, 140, 150, 30);
    lblKHCP.setFont(fontMain);
    pnlChuyenPhong.add(lblKHCP);

    dfModelLoaiPhongCanChuyen = new DefaultComboBoxModel<String>();
    dfModelLoaiPhongCanChuyen.addElement("Chọn loại phòng");
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      dfModelLoaiPhongCanChuyen.addElement(t.getLoaiPhong().trim());
    }

    cmbLoaiPhongCanChuyen = new JComboBox<String>(dfModelLoaiPhongCanChuyen);
    cmbLoaiPhongCanChuyen.setFont(fontMain);
    cmbLoaiPhongCanChuyen.setBounds(180, 20, 150, 25);
    cmbLoaiPhongCanChuyen.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbLoaiPhongCanChuyen.setSelectedIndex(0);
    pnlChuyenPhong.add(cmbLoaiPhongCanChuyen);

    dfModelLoaiPhongChuyenToi = new DefaultComboBoxModel<String>();
    dfModelLoaiPhongChuyenToi.addElement("Chọn loại phòng");
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      dfModelLoaiPhongChuyenToi.addElement(t.getLoaiPhong().trim());
    }

    cmbLoaiPhongChuyenToi = new JComboBox<String>(dfModelLoaiPhongChuyenToi);
    cmbLoaiPhongChuyenToi.setFont(fontMain);
    cmbLoaiPhongChuyenToi.setBounds(580, 20, 150, 25);
    cmbLoaiPhongChuyenToi.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbLoaiPhongChuyenToi.setSelectedIndex(0);

    pnlChuyenPhong.add(cmbLoaiPhongChuyenToi);

    dfModelPhongCanChuyen = new DefaultComboBoxModel<String>();
    dfModelPhongCanChuyen.addElement("Chọn phòng");
    datPhongService.dsPhongThuong().forEach((phong) -> {
      if (phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
        dfModelPhongCanChuyen.addElement(phong.getTenPhong().trim());
      }
    });
    int c = dfModelPhongCanChuyen.getSize();
    if (c == 0) {
      dfModelPhongCanChuyen.addElement("Trống");
    }
    cmbPhongCanChuyen = new JComboBox<String>(dfModelPhongCanChuyen);
    cmbPhongCanChuyen.setFont(fontMain);
    cmbPhongCanChuyen.setBounds(180, 50, 150, 25);
    cmbPhongCanChuyen.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbPhongCanChuyen.setEnabled(false);
    pnlChuyenPhong.add(cmbPhongCanChuyen);

    dfModelPhongChuyenToi = new DefaultComboBoxModel<String>();
    dfModelPhongChuyenToi.addElement("Chọn phòng");
    datPhongService.dsPhongThuong().forEach((phong) -> {
      if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
        dfModelPhongChuyenToi.addElement(phong.getTenPhong().trim());
      }
    });
    int count = dfModelPhongChuyenToi.getSize();
    if (count == 0) {
      dfModelPhongChuyenToi.removeAllElements();
      dfModelPhongChuyenToi.addElement(HET_PHONG);
    }
    cmbPhongChuyenToi = new JComboBox<String>(dfModelPhongChuyenToi);
    cmbPhongChuyenToi.setFont(fontMain);
    cmbPhongChuyenToi.setBounds(580, 50, 150, 25);
    cmbPhongChuyenToi.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbPhongChuyenToi.setEditable(false);
    pnlChuyenPhong.add(cmbPhongChuyenToi);

    lblGiaPhongCanChuyen = new JLabel("200000");
    lblGiaPhongCanChuyen.setBounds(180, 80, 200, 30);
    lblGiaPhongCanChuyen.setFont(fontMain);
    pnlChuyenPhong.add(lblGiaPhongCanChuyen);

    lblGiaPhongChuyenToi = new JLabel("200000");
    lblGiaPhongChuyenToi.setBounds(580, 80, 200, 30);
    lblGiaPhongChuyenToi.setFont(fontMain);
    pnlChuyenPhong.add(lblGiaPhongChuyenToi);

    lblSucChuaCanChuyen = new JLabel("20");
    lblSucChuaCanChuyen.setBounds(180, 110, 200, 30);
    lblSucChuaCanChuyen.setFont(fontMain);
    pnlChuyenPhong.add(lblSucChuaCanChuyen);

    lblSucChuaChuyenToi = new JLabel("20");
    lblSucChuaChuyenToi.setBounds(580, 110, 200, 30);
    lblSucChuaChuyenToi.setFont(fontMain);
    pnlChuyenPhong.add(lblSucChuaChuyenToi);

    lblKhachHangCanChuyen = new JLabel();
    lblKhachHangCanChuyen.setBounds(180, 140, 400, 30);
    lblKhachHangCanChuyen.setFont(fontMain);
    pnlChuyenPhong.add(lblKhachHangCanChuyen);

    btnCfChuyenPhong = new MyButton(30, Color.decode(Constants.BTN_CONFIRM_COLOR),
        Color.decode(Constants.BTN_CONFIRM_COLOR));
    btnCfChuyenPhong.setText("Chuyển phòng");
    btnCfChuyenPhong.setBorderPainted(false);
    btnCfChuyenPhong.setFocusPainted(false);
    btnCfChuyenPhong.setBounds(360, 60, 170, 50);
    btnCfChuyenPhong.setFont(fontMain);
    btnCfChuyenPhong.setCursor(handleCursor);

    pnlChuyenPhong.add(btnCfChuyenPhong);

    String[] header = { "Tên Dịch Vụ", "Giá", "Số Lượng", "Thành Tiền" };
    modelDichVu = new DefaultTableModel(header, 0);
    tblDichVu = new JTable(modelDichVu);

    tblDichVu.getTableHeader().setFont(new Font(Constants.MAIN_FONT, 0, 15));
    tblDichVu.setRowHeight(30);
    tblDichVu.setBackground(Color.decode(Constants.MAIN_COLOR));
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    tblDichVu.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
    tblDichVu.getColumnModel().getColumn(1).setCellRenderer(centerRenderer);
    tblDichVu.getColumnModel().getColumn(2).setCellRenderer(centerRenderer);
    tblDichVu.getColumnModel().getColumn(3).setCellRenderer(centerRenderer);
    tblDichVu.setFont(new Font(Constants.MAIN_FONT, 0, 15));
    tblDichVu.getTableHeader().setBackground(Color.decode(Constants.MAIN_COLOR));

    JScrollPane sp = new JScrollPane(tblDichVu);
    sp.setBackground(Color.decode(Constants.MAIN_COLOR));
    sp.setBounds(25, 180, 700, 170);
    pnlChuyenPhong.add(sp);

    pnlCenterLeft.add(pnlChuyenPhong);
    btnCfChuyenPhong.addActionListener(this);

    cmbLoaiPhongCanChuyen.addActionListener(this);
    cmbLoaiPhongChuyenToi.addActionListener(this);
    cmbPhongCanChuyen.addActionListener(this);
    cmbPhongChuyenToi.addActionListener(this);
  }

  private void UiDatPhong() {

    dateSettings = new DatePickerSettings();
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);

    lblngayDatPhong = new JLabel("Ngày đặt phòng");
    lblngayDatPhong.setBounds(20, 20, 150, 30);
    lblngayDatPhong.setFont(fontMain);
    ngayDatDatPhong = new DatePicker(dateSettings);

    ngayDatDatPhong.setBounds(170, 20, 150, 30);
    ngayDatDatPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    ngayDatDatPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 100));
    ngayDatDatPhong.setDate(new Date().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
    pnlDatPhong.add(lblngayDatPhong);
    pnlDatPhong.add(ngayDatDatPhong);

    lblGioNhanPhong = new JLabel("Giờ nhận phòng");
    lblGioNhanPhong.setBounds(20, 70, 150, 30);
    lblGioNhanPhong.setFont(fontMain);
    dfModelGioDat = new DefaultComboBoxModel<String>();
    dfModelGioDat.addElement("Chọn giờ");

    for (int i = 8; i <= 22; i += 2) {
      if (i < 10) {
        dfModelGioDat.addElement("0" + i + ":00");
      } else {
        dfModelGioDat.addElement(i + ":00");
      }
    }
    cmbGioDat = new JComboBox<String>(dfModelGioDat);
    cmbGioDat.setEnabled(false);
    cmbGioDat.setBounds(170, 70, 150, 30);
    cmbGioDat.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbGioDat.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    pnlDatPhong.add(lblGioNhanPhong);
    pnlDatPhong.add(cmbGioDat);

    ngayDatDatPhong.addDateChangeListener(new DateChangeListener() {
      @Override
      public void dateChanged(DateChangeEvent dce) {
        cmbGioDat.setEnabled(false);
        ngayDat = dce.getNewDate().toString();
        cmbGioDat.removeAllItems();
        for (int i = 8; i <= 22; i += 2) {
          if (i < 10) {
            dfModelGioDat.addElement("0" + i + ":00");
          } else {
            dfModelGioDat.addElement(i + ":00");
          }
        }
      }
    });

    String ngayDatPhong = ngayDat != null ? ngayDat : ngayDatDatPhong.getDate().toString();
    List<DatPhong> listDatPhong = datPhongService
        .dsNgayDat(ngayDatPhong);
    for (int i = 0; i < listDatPhong.size(); i++) {
      for (Phong dp : phongService.dsPhong()) {
        if (dp.getMaPhong().equals(listDatPhong.get(i).getPhong().getMaPhong())) {

          String gioDat = new SimpleDateFormat("HH:mm")
              .format(datPhongService.dsNgayDat(ngayDatPhong).get(i).getGioNhanPhong());
          for (int j = 0; j < dfModelGioDat.getSize(); j++) {
            if (gioDat.equals(dfModelGioDat.getElementAt(j))) {
              cmbGioDat.removeItemAt(j);
            }
          }
        }
      }
    }
    lblLoaiPhong = new JLabel("Loại phòng");
    lblLoaiPhong.setBounds(20, 120, 150, 30);
    lblLoaiPhong.setFont(fontMain);

    dfModelLoaiPhong = new DefaultComboBoxModel<String>();
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      dfModelLoaiPhong.addElement(t.getLoaiPhong());
    }

    cmbLoaiPhong = new JComboBox<String>(dfModelLoaiPhong);
    cmbLoaiPhong.setFont(fontMain);
    cmbLoaiPhong.setBorder(null);
    cmbLoaiPhong.setBounds(170, 120, 150, 30);
    cmbLoaiPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblLoaiPhong);
    pnlDatPhong.add(cmbLoaiPhong);

    lblLoaiPhong = new JLabel("Phòng");
    lblLoaiPhong.setBounds(20, 170, 150, 30);
    lblLoaiPhong.setFont(fontMain);
    dfModelPhong = new DefaultComboBoxModel<String>();
    dfModelPhong.addElement("Chọn phòng");
    datPhongService.dsPhongThuong().forEach((phong) -> {
      if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
        if (phong.getSoLanDatTruoc() < 8)
          dfModelPhong.addElement(phong.getTenPhong().trim());
      }
    });
    int count = dfModelPhong.getSize();
    if (count == 0) {
      dfModelPhong.removeAllElements();
      dfModelPhong.addElement(HET_PHONG);
    }
    dfModelPhong.setSelectedItem(dfModelPhong.getElementAt(0));
    cmbPhong = new JComboBox<String>(dfModelPhong);
    cmbPhong.setFont(fontMain);
    cmbPhong.setBounds(170, 170, 150, 30);
    cmbPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblLoaiPhong);
    pnlDatPhong.add(cmbPhong);

    lblSucChua = new JLabel("Sức chứa");
    lblSucChua.setBounds(20, 220, 400, 30);
    lblSucChua.setFont(fontMain);

    txtSucChua = new JTextField("20");
    txtSucChua.setEditable(false);
    txtSucChua.setFont(fontMain);
    txtSucChua.setBounds(170, 220, 150, 30);
    txtSucChua.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblSucChua);
    pnlDatPhong.add(txtSucChua);

    lblgiaPhong = new JLabel("Giá tiền");
    lblgiaPhong.setBounds(20, 270, 400, 30);
    lblgiaPhong.setFont(fontMain);
    txtgiaPhong = new JTextField("200000");
    txtgiaPhong.setBounds(170, 270, 150, 30);
    txtgiaPhong.setEditable(false);
    txtgiaPhong.setFont(fontMain);
    txtgiaPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblgiaPhong);
    pnlDatPhong.add(txtgiaPhong);

    cmbLoaiPhong.addActionListener(this);
    cmbPhong.addActionListener(this);
  }

  private void UiKhach() {

    lblTenKH = new JLabel("Tên khách hàng");
    lblTenKH.setBounds(340, 20, 150, 30);
    lblTenKH.setFont(fontMain);
    txtTenKH = new JTextField("");
    txtTenKH.setFont(fontMain);
    txtTenKH.setEditable(false);
    txtTenKH.setBounds(500, 20, 230, 30);
    txtTenKH.setBackground(Color.decode(Constants.INPUT_COLOR));
    txtTenKH.setBorder(null);
    pnlDatPhong.add(lblTenKH);
    pnlDatPhong.add(txtTenKH);

    lblSdt = new JLabel("Số điện thoại");
    lblSdt.setBounds(340, 70, 350, 30);
    lblSdt.setFont(fontMain);
    txtSdt = new JTextField("");
    txtSdt.setFont(fontMain);
    txtSdt.setCursor(new Cursor(Cursor.TEXT_CURSOR));
    txtSdt.setBounds(500, 70, 230, 30);
    txtSdt.setBackground(Color.decode(Constants.INPUT_COLOR));
    txtSdt.setBorder(null);
    pnlDatPhong.add(lblSdt);
    pnlDatPhong.add(txtSdt);

    lblTV = new JLabel("Loại thành viên");
    lblTV.setBounds(340, 120, 350, 30);
    lblTV.setFont(fontMain);
    txtLoaiTV = new JTextField();
    txtLoaiTV.setEditable(false);
    txtLoaiTV.setFont(fontMain);
    txtLoaiTV.setBounds(500, 120, 230, 30);
    txtLoaiTV.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblTV);
    pnlDatPhong.add(txtLoaiTV);

    lblDiaChi = new JLabel("Địa chỉ");
    lblDiaChi.setBounds(340, 170, 150, 30);
    lblDiaChi.setFont(fontMain);
    txaDiachi = new JTextArea("");
    txaDiachi.setFont(fontMain);
    txaDiachi.setEditable(false);
    txaDiachi.setLineWrap(true);
    txaDiachi.setWrapStyleWord(true);
    txaDiachi.setBounds(500, 170, 230, 100);
    txaDiachi.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlDatPhong.add(lblDiaChi);
    pnlDatPhong.add(txaDiachi);

    lblGioiTinh = new JLabel("Giới tính");
    lblGioiTinh.setBounds(340, 270, 250, 30);
    lblGioiTinh.setFont(fontMain);
    chkGioiTinh = new JCheckBox("Nam");
    chkGioiTinh.setBounds(500, 270, 100, 30);
    chkGioiTinh.setFont(fontMain);
    chkGioiTinh.setBackground(Color.decode(Constants.MAIN_COLOR));
    pnlDatPhong.add(lblGioiTinh);
    pnlDatPhong.add(chkGioiTinh);

    txtSdt.addActionListener(this);
  }

  private void UISuaPhong() {
    dateSettings = new DatePickerSettings();
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);

    lblngayDatPhong = new JLabel("Ngày đặt phòng");
    lblngayDatPhong.setBounds(20, 20, 150, 30);
    lblngayDatPhong.setFont(fontMain);
    ngayDatDatPhong = new DatePicker(dateSettings);

    ngayDatDatPhong.setBounds(170, 20, 150, 30);
    ngayDatDatPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    ngayDatDatPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 100));
    ngayDatDatPhong.setDate(new Date().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
    pnlSuaPhong.add(lblngayDatPhong);
    pnlSuaPhong.add(ngayDatDatPhong);

    lblGioNhanPhong = new JLabel("Giờ nhận phòng");
    lblGioNhanPhong.setBounds(20, 70, 150, 30);
    lblGioNhanPhong.setFont(fontMain);
    dfModelGioDat = new DefaultComboBoxModel<String>();
    for (int i = 8; i <= 22; i += 2) {
      if (i < 10) {
        dfModelGioDat.addElement("0" + i + ":00");
      } else {
        dfModelGioDat.addElement(i + ":00");
      }
    }
    cmbGioDat = new JComboBox<String>(dfModelGioDat);

    cmbGioDat.setBounds(170, 70, 150, 30);
    cmbGioDat.setBackground(Color.decode(Constants.INPUT_COLOR));
    cmbGioDat.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    pnlSuaPhong.add(lblGioNhanPhong);
    pnlSuaPhong.add(cmbGioDat);

    ngayDatDatPhong.addDateChangeListener(new DateChangeListener() {
      @Override
      public void dateChanged(DateChangeEvent dce) {
        ngayDat = dce.getNewDate().toString();
        cmbGioDat.removeAllItems();
        for (int i = 8; i <= 22; i += 2) {
          if (i < 10) {
            dfModelGioDat.addElement("0" + i + ":00");
          } else {
            dfModelGioDat.addElement(i + ":00");
          }
        }
      }
    });
    String ngayDatPhong = ngayDat != null ? ngayDat : ngayDatDatPhong.getDate().toString();
    List<DatPhong> listDatPhong = datPhongService
        .dsNgayDat(ngayDatPhong);
    for (int i = 0; i < listDatPhong.size(); i++) {
      for (Phong dp : phongService.dsPhong()) {
        if (dp.getMaPhong().equals(listDatPhong.get(i).getPhong().getMaPhong())) {

          String gioDat = new SimpleDateFormat("HH:mm")
              .format(datPhongService.dsNgayDat(ngayDatPhong).get(i).getGioNhanPhong());
          for (int j = 0; j < dfModelGioDat.getSize(); j++) {
            if (gioDat.equals(dfModelGioDat.getElementAt(j))) {
              cmbGioDat.removeItemAt(j);
            }
          }
        }
      }
    }
    lblLoaiPhong = new JLabel("Loại phòng");
    lblLoaiPhong.setBounds(20, 120, 150, 30);
    lblLoaiPhong.setFont(fontMain);

    dfModelLoaiPhong = new DefaultComboBoxModel<String>();
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      dfModelLoaiPhong.addElement(t.getLoaiPhong());
    }

    cmbLoaiPhong = new JComboBox<String>(dfModelLoaiPhong);
    cmbLoaiPhong.setFont(fontMain);
    cmbLoaiPhong.setBorder(null);
    cmbLoaiPhong.setBounds(170, 120, 150, 30);
    cmbLoaiPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblLoaiPhong);
    pnlSuaPhong.add(cmbLoaiPhong);

    lblLoaiPhong = new JLabel("Phòng");
    lblLoaiPhong.setBounds(20, 170, 150, 30);
    lblLoaiPhong.setFont(fontMain);
    dfModelPhong = new DefaultComboBoxModel<String>();
    dfModelPhong.addElement("Chọn phòng");

    datPhongService.dsPhongThuong().forEach((phong) -> {
      if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
        if (phong.getSoLanDatTruoc() < 8)
          dfModelPhong.addElement(phong.getTenPhong().trim());
      }
    });
    int count = dfModelPhong.getSize();
    if (count == 0) {
      dfModelPhong.removeAllElements();
      dfModelPhong.addElement(HET_PHONG);
    }
    dfModelPhong.setSelectedItem(dfModelPhong.getElementAt(0));
    cmbPhong = new JComboBox<String>(dfModelPhong);
    cmbPhong.setFont(fontMain);
    cmbPhong.setBounds(170, 170, 150, 30);
    cmbPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblLoaiPhong);
    pnlSuaPhong.add(cmbPhong);

    lblSucChua = new JLabel("Sức chứa");
    lblSucChua.setBounds(20, 220, 400, 30);
    lblSucChua.setFont(fontMain);

    txtSucChua = new JTextField("20");
    txtSucChua.setEditable(false);
    txtSucChua.setFont(fontMain);
    txtSucChua.setBounds(170, 220, 150, 30);
    txtSucChua.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblSucChua);
    pnlSuaPhong.add(txtSucChua);

    lblgiaPhong = new JLabel("Giá tiền");
    lblgiaPhong.setBounds(20, 270, 400, 30);
    lblgiaPhong.setFont(fontMain);
    txtgiaPhong = new JTextField("200.000");
    txtgiaPhong.setBounds(170, 270, 150, 30);
    txtgiaPhong.setEditable(false);
    txtgiaPhong.setFont(fontMain);
    txtgiaPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblgiaPhong);
    pnlSuaPhong.add(txtgiaPhong);

    cmbLoaiPhong.addActionListener(this);
    cmbPhong.addActionListener(this);
  }

  private void UiSuaKhach() {

    lblTenKH = new JLabel("Tên khách hàng");
    lblTenKH.setBounds(340, 20, 150, 30);
    lblTenKH.setFont(fontMain);
    txtTenKH = new JTextField("");
    txtTenKH.setFont(fontMain);
    txtTenKH.setBounds(500, 20, 230, 30);
    txtTenKH.setBackground(Color.decode(Constants.INPUT_COLOR));
    txtTenKH.setBorder(null);
    pnlSuaPhong.add(lblTenKH);
    pnlSuaPhong.add(txtTenKH);

    lblSdt = new JLabel("Số điện thoại");
    lblSdt.setBounds(340, 70, 350, 30);
    lblSdt.setFont(fontMain);
    txtSdt = new JTextField("");
    txtSdt.setFont(fontMain);
    txtSdt.setBounds(500, 70, 230, 30);
    txtSdt.setBackground(Color.decode(Constants.INPUT_COLOR));
    txtSdt.setBorder(null);
    pnlSuaPhong.add(lblSdt);
    pnlSuaPhong.add(txtSdt);

    lblTV = new JLabel("Loại thành viên");
    lblTV.setBounds(340, 120, 350, 30);
    lblTV.setFont(fontMain);
    txtLoaiTV = new JTextField();
    txtLoaiTV.setEditable(false);
    txtLoaiTV.setFont(fontMain);
    txtLoaiTV.setBounds(500, 120, 230, 30);
    txtLoaiTV.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblTV);
    pnlSuaPhong.add(txtLoaiTV);

    lblDiaChi = new JLabel("Địa chỉ");
    lblDiaChi.setBounds(340, 170, 150, 30);
    lblDiaChi.setFont(fontMain);
    txaDiachi = new JTextArea("");
    txaDiachi.setFont(fontMain);
    txaDiachi.setLineWrap(true);
    txaDiachi.setBounds(500, 170, 230, 100);
    txaDiachi.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlSuaPhong.add(lblDiaChi);
    pnlSuaPhong.add(txaDiachi);

    lblGioiTinh = new JLabel("Giới tính");
    lblGioiTinh.setBounds(340, 270, 250, 30);
    lblGioiTinh.setFont(fontMain);
    chkGioiTinh = new JCheckBox("Nam");
    chkGioiTinh.setBounds(500, 270, 100, 30);
    chkGioiTinh.setFont(fontMain);
    chkGioiTinh.setBackground(Color.decode(Constants.MAIN_COLOR));
    pnlSuaPhong.add(lblGioiTinh);
    pnlSuaPhong.add(chkGioiTinh);

    txtSdt.addActionListener(this);
  }

  private void dynamicThongTinDichVu(List<ChiTietDichVu> dsDV) {
    modelDichVu.setRowCount(0);
    for (ChiTietDichVu dv : dsDV) {
      modelDichVu.addRow(
          new Object[] { dv.getDichVu().getTenDichVu(), dv.getDichVu().getGiaDichVu(), dv.getSoLuong(),
              dv.getSoLuong() * dv.getDichVu().getGiaDichVu() });
    }
  }

  private void danhSachPhong(List<Phong> dsPhong, int index) {
    int a = 0;
    int c = 0;
    int length = dsPhong.size();
    pnlSubDanhSachPhong = new JPanel();
    pnlSubDanhSachPhong.setLayout(null);
    pnlSubDanhSachPhong.setBounds(10, 60, 680, 450);
    pnlSubDanhSachPhong.setBackground(Color.decode(Constants.MAIN_COLOR));

    try {
      URL roomURL = new URL(Constants.ICON_ROOM);
      Image room = new ImageIcon(roomURL).getImage().getScaledInstance(50, 50, Image.SCALE_SMOOTH);

      for (a = index; a < length; index++) {
        btnPhongList = new SpecialButton(20, Color.decode(Constants.BTN_CONFIRM_COLOR),
            Color.decode(Constants.MAIN_COLOR));
        btnPhongList.setIcon(new ImageIcon(room));
        btnPhongList.setLayout(null);
        if (dsPhong.get(index).getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
          btnPhongList.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
        } else if (dsPhong.get(index).getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
          btnPhongList.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
        } else
          btnPhongList.setBackground(Color.decode(Constants.MENU_TITLE_COLOR));
        btnPhongList.setBounds(40 + (c % 4) * 170, 10 + (c / 4) * 150, 120, 120);
        btnPhongList.setBorderPainted(false);
        btnPhongList.setFocusPainted(false);
        btnPhongList.setCursor(handleCursor);

        lblPhongList = new JLabel(dsPhong.get(index).getTenPhong().trim());
        lblPhongList.setBounds(10, 45, 120, 120);
        lblPhongList.setFont(fontLb);
        btnPhongList.add(lblPhongList);
        btnPhongList.addActionListener(this);
        pnlSubDanhSachPhong.add(btnPhongList);
        c++;
        a++;
      }

    } catch (Exception e) {
      JOptionPane.showMessageDialog(null, "Có lỗi xảy ra xin hãy báo với quản trị viên");
    }

    pnlDanhSachPhong.add(pnlSubDanhSachPhong, 1);
  }

  private void danhSachPhongFilter(List<Phong> dsPhong, TrangThaiPhongEnum tt, int index) {
    List<Phong> dsPhongFilter = new ArrayList<Phong>();
    for (int i = 0; i < dsPhong.size(); i++) {
      if (dsPhong.get(i).getTtPhong().equals(tt)) {
        dsPhongFilter.add(dsPhong.get(i));
      }
    }
    int a = 0;
    int c = 0;
    int length = dsPhongFilter.size();
    pnlSubDanhSachPhong = new JPanel();
    pnlSubDanhSachPhong.setLayout(null);
    pnlSubDanhSachPhong.setBounds(10, 60, 680, 450);
    pnlSubDanhSachPhong.setBackground(Color.decode(Constants.MAIN_COLOR));

    try {
      URL roomURL = new URL(Constants.ICON_ROOM);
      Image room = new ImageIcon(roomURL).getImage().getScaledInstance(50, 50, Image.SCALE_SMOOTH);

      for (a = index; a < length; index++) {
        btnPhongList = new SpecialButton(20, Color.decode(Constants.BTN_CONFIRM_COLOR),
            Color.decode(Constants.MAIN_COLOR));

        btnPhongList.setIcon(new ImageIcon(room));
        btnPhongList.setLayout(null);
        if (dsPhongFilter.get(index).getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
          btnPhongList.setBackground(Color.decode(Constants.BTN_CONFIRM_COLOR));
        } else if (dsPhongFilter.get(index).getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
          btnPhongList.setBackground(Color.decode(Constants.BTN_EDIT_COLOR));
        } else
          btnPhongList.setBackground(Color.decode(Constants.MENU_TITLE_COLOR));
        btnPhongList.setBounds(40 + (c % 4) * 170, 10 + (c / 4) * 150, 120, 120);

        btnPhongList.setBorderPainted(false);
        btnPhongList.setFocusPainted(false);
        btnPhongList.setCursor(handleCursor);

        lblPhongList = new JLabel(dsPhongFilter.get(index).getTenPhong().trim());
        lblPhongList.setBounds(10, 45, 120, 120);
        lblPhongList.setFont(fontLb);
        btnPhongList.add(lblPhongList);
        btnPhongList.addActionListener(this);
        pnlSubDanhSachPhong.add(btnPhongList);
        c++;
        a++;
      }

    } catch (Exception e) {
      JOptionPane.showMessageDialog(null, "Có lỗi xảy ra xin hãy báo với quản trị viên");
    }
    pnlDanhSachPhong.add(pnlSubDanhSachPhong, 1);
  }

  private void DsPhongCho() {
    pnlPhongcho = new JPanel();
    TitledBorder titlDanhSach = new TitledBorder(BorderFactory.createLineBorder(Color.black),
        "Danh sách phòng đặt trước");
    pnlPhongcho.setBorder(titlDanhSach);
    pnlPhongcho.setLayout(null);
    pnlPhongcho.setBounds(10, 430, 750, 190);
    pnlPhongcho.setBackground(Color.decode(Constants.MAIN_COLOR));
    String[] header = { "Tên khách hàng", "Loại thành viên", "Phòng", "Loại phòng", "Ngày đặt", "Giờ nhận",
        "Xóa phòng", "maDP", "maKH", "maPhong", "Sức chứa", "Giá tiền" };
    modelPhongCho = new DefaultTableModel(header, 0);
    tblPhongCho = new JTable(modelPhongCho);
    tblPhongCho.setSelectionBackground(Color.white);
    tblPhongCho.getColumnModel().getColumn(7).setMinWidth(0);
    tblPhongCho.getColumnModel().getColumn(7).setMaxWidth(0);
    tblPhongCho.getColumnModel().getColumn(7).setWidth(0);
    tblPhongCho.getColumnModel().getColumn(8).setMinWidth(0);
    tblPhongCho.getColumnModel().getColumn(8).setMaxWidth(0);
    tblPhongCho.getColumnModel().getColumn(8).setWidth(0);
    tblPhongCho.getColumnModel().getColumn(9).setMinWidth(0);
    tblPhongCho.getColumnModel().getColumn(9).setMaxWidth(0);
    tblPhongCho.getColumnModel().getColumn(9).setWidth(0);
    tblPhongCho.getColumnModel().getColumn(10).setMinWidth(0);
    tblPhongCho.getColumnModel().getColumn(10).setMaxWidth(0);
    tblPhongCho.getColumnModel().getColumn(10).setWidth(0);
    tblPhongCho.getColumnModel().getColumn(11).setMinWidth(0);
    tblPhongCho.getColumnModel().getColumn(11).setMaxWidth(0);
    tblPhongCho.getColumnModel().getColumn(11).setWidth(0);

    tblPhongCho.setRowHeight(40);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    tblPhongCho.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(1).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(2).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(3).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(4).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(5).setCellRenderer(centerRenderer);
    tblPhongCho.getColumnModel().getColumn(6).setCellRenderer(centerRenderer);
    tblPhongCho.setDefaultEditor(Object.class, null);
    tblPhongCho.setCursor(handleCursor);
    dynamicPhongCho(datPhongService.dsPhongDatTruoc(), null);
    JScrollPane scrollPane = new JScrollPane(tblPhongCho);
    scrollPane.setBounds(10, 20, 730, 160);

    pnlPhongcho.add(scrollPane);
    pnlCenterLeft.add(pnlPhongcho);
    tblPhongCho.addMouseListener(this);

  }

  class ButtonEditor extends DefaultCellEditor {
    private String label;

    public ButtonEditor(JCheckBox checkBox) {
      super(checkBox);
    }

    public Component getTableCellEditorComponent(JTable table, Object value,
        boolean isSelected, int row, int column) {
      label = (value == null) ? "" : value.toString();
      button.setText(label);
      FontIcon close = FontIcon.of(FontAwesomeSolid.TIMES, 20);
      button.setIcon(close);
      button.setBackground(Color.WHITE);
      button.setBorderPainted(false);
      button.setFocusPainted(false);
      return button;
    }

    public Object getCellEditorValue() {
      return new String(label);
    }
  }

  class ButtonRenderer extends JButton implements TableCellRenderer {
    public ButtonRenderer() {
      setOpaque(true);
    }

    public Component getTableCellRendererComponent(JTable table, Object value,
        boolean isSelected, boolean hasFocus, int row, int column) {
      setText((value == null) ? "" : value.toString());
      setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
      setBackground(Color.WHITE);
      return this;
    }

  }

  void dynamicPhongCho(List<DatPhong> dsPhongCho, String loaiPhong) {
    button = new JButton();
    tblPhongCho.getColumn("Xóa phòng").setCellRenderer(new ButtonRenderer());
    tblPhongCho.getColumn("Xóa phòng").setCellEditor(new ButtonEditor(new JCheckBox()));
    button.addActionListener(
        new ActionListener() {
          public void actionPerformed(ActionEvent event) {
            int row = tblPhongCho.getSelectedRow();
            int thongbao = JOptionPane.showConfirmDialog(null, "Bạn có chắc muốn xóa",
                "Cảnh cáo", JOptionPane.YES_NO_OPTION);
            if (thongbao == JOptionPane.YES_OPTION) {
              String loaiPhong = tblPhongCho.getValueAt(row, 3).toString();
              if (datPhongService.xoaPhongDat(tblPhongCho.getModel().getValueAt(row, 7).toString())) {
                if (phong.getSoLanDatTruoc() > 0) {
                  phongService.traPhong(phong.getMaPhong(), TrangThaiPhongEnum.DAT_TRUOC.name());
                } else {
                  phongService.traPhong(phong.getMaPhong(), TrangThaiPhongEnum.TRONG.name());
                }
                modelPhongCho.removeRow(row);
                JOptionPane.showMessageDialog(null, "xóa thành công");
                loadData(loaiPhong);
              } else
                JOptionPane.showMessageDialog(null, "Xóa không thành công");
            }

          }
        });
    for (DatPhong dp : dsPhongCho) {
      String gioDat = new SimpleDateFormat("HH:mm").format(dp.getGioNhanPhong());
      String ngayDat = new SimpleDateFormat("dd/MM/yyyy").format(dp.getngayDatPhong());
      if (loaiPhong == null) {

        modelPhongCho.addRow(
            new Object[] { dp.getKhachHang().getTenKH().trim(),
                dp.getKhachHang().getLoaiTV().getTenLoaiTV() == null ? "Khách lẻ"
                    : dp.getKhachHang().getLoaiTV().getTenLoaiTV().trim(),
                dp.getPhong().getTenPhong().trim(),
                dp.getPhong().getLoaiPhong().getLoaiPhong(), ngayDat, gioDat, button.getText(),
                dp.getMaDP(), dp.getKhachHang().getMaKH(), dp.getPhong().getMaPhong(), dp.getPhong().getSucChua(),
                dp.getPhong().getgiaPhong() });

      } else {
        if (dp.getPhong().getLoaiPhong().getLoaiPhong().equals(loaiPhong)) {
          modelPhongCho.addRow(
              new Object[] { dp.getKhachHang().getTenKH().trim(),
                  dp.getKhachHang().getLoaiTV().getTenLoaiTV() == null ? "Khách lẻ"
                      : dp.getKhachHang().getLoaiTV().getTenLoaiTV().trim(),
                  dp.getPhong().getTenPhong().trim(),
                  dp.getPhong().getLoaiPhong().getLoaiPhong(), ngayDat, gioDat, button.getText(),
                  dp.getMaDP(), dp.getKhachHang().getMaKH(), dp.getPhong().getMaPhong(), dp.getPhong().getSucChua(),
                  dp.getPhong().getgiaPhong() });
        }
      }

    }

  }

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    try {
      if (e.getSource() == btnPhong) {
        new QuanLyPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnKhachHang) {
        new QuanLyKhachHang(tk, "").setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnNhanVien) {
        new QLNhanVien(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnHoaDon) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnThongke) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnPhanCong) {
        new PhanCongCaLam(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      } else if (e.getSource() == btnIconUser) {
        new ThongTinNguoiDung(tk).setVisible(true);
      } else if (e.getSource() == btnIconLogout) {
        int tb = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn đăng xuất không", "Cảnh báo",
            JOptionPane.YES_NO_OPTION);
        if (tb == JOptionPane.YES_OPTION) {

          for (Frame frame : Frame.getFrames()) {
            frame.dispose();
          }
          new DangNhap().setVisible(true);
        }
      }
    } catch (Exception e1) {
      e1.printStackTrace();
    }

    if (e.getSource() == btnXacNhanDatPhong) {
      String value = cmbPhong.getSelectedItem().toString();
      for (Phong phong : phongService.dsPhong()) {
        if (phong.getTenPhong().trim().equals(value)) {
          maPhong = phong.getMaPhong();
          break;
        }
      }
      String loaiPhong = (String) cmbLoaiPhong.getSelectedItem();
      String tenPhong = (String) cmbPhong.getSelectedItem();
      String gioNhan = "";
      if (cmbGioDat.getSelectedIndex() > 0) {
        gioNhan = (String) cmbGioDat.getSelectedItem();
      } else {
        JOptionPane.showMessageDialog(null, "Vui lòng chọn khung giờ đặt phòng", "Thông báo",
            JOptionPane.ERROR_MESSAGE);
        return;
      }
      if (txtSdt.getText().isEmpty()) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập thông tin khách hàng đặt phòng", "Cảnh báo",
            JOptionPane.ERROR_MESSAGE);
        txtSdt.requestFocus();
      }
      int sucChua = Integer.parseInt(txtSucChua.getText());
      double giaPhong = Double.parseDouble(txtgiaPhong.getText());
      phong = new Phong(maPhong, tenPhong, giaPhong, sucChua, TrangThaiPhongEnum.DAT_TRUOC,
          loaiPhong == "VIP" ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG);

      SimpleDateFormat formatterGio = new SimpleDateFormat("dd/MM/yyyy HH:mm");
      SimpleDateFormat formatterNgay = new SimpleDateFormat("dd/MM/yyyy");

      Date gioNhanPhong = null;
      datPhong = new DatPhong();
      NhanVien nv = new NhanVien();
      nv.setMaNV(nhanVien.getMaNV());
      String ngayDat = generator.parseLocalDateToDate(ngayDatDatPhong.getDate().toString());
      Date ngayDatPhong = null;
      if (txtSdt.getText().isEmpty() || khachHang == null) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập thông tin khách hàng đặt phòng", "Cảnh báo",
            JOptionPane.ERROR_MESSAGE);
        txtSdt.requestFocus();
        return;
      }

      try {
        ngayDatPhong = formatterNgay.parse(ngayDat);
        gioNhanPhong = formatterGio.parse(ngayDat + " " + gioNhan);
        datPhong.setMaDP(generator.tuTaoDatPhong());
        datPhong.setngayDatPhong(ngayDatPhong);
        datPhong.setGioNhanPhong(gioNhanPhong);
        datPhong.setKhachHang(khachHang);
        datPhong.setPhong(phong);
        datPhong.setNhanVien(nv);
        if (datPhongService.datPhong(datPhong)) {
          JOptionPane.showMessageDialog(null, "Đặt phòng thành công", "Thông báo",
              JOptionPane.INFORMATION_MESSAGE);
          phongService.dsPhong();
          pnlSubDanhSachPhong.removeAll();
          datPhongService.dsPhongDatTruoc();
          loadData(phong.getLoaiPhong().name());
          modelPhongCho.setRowCount(0);
          datPhongService.dsPhongDatTruoc();
          dynamicPhongCho(datPhongService.dsPhongDatTruoc(), null);
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtTenKH.setText("");
          txtSdt.setText("");
          txtLoaiTV.setText("");
          txaDiachi.setText("");
          cmbGioDat.removeItem(gioNhan);
          cmbGioDat.setEnabled(false);
          if (ngayDatPhong.compareTo(new Date()) < 0) {
            ngayDatDatPhong.setDate(new Date().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
          }
        }

      } catch (Exception e1) {
        e1.printStackTrace();
      }
    } else if (e.getSource() == btnDatPhong) {
      flagPhong = false;
      if (pnlChuyenPhong != null) {
        pnlCenterLeft.remove(pnlChuyenPhong);
        pnlChuyenPhong.removeAll();
      }
      if (pnlSuaPhong != null) {
        pnlCenterLeft.remove(pnlSuaPhong);
        pnlSuaPhong.removeAll();
      }
      DatPhong();
      pnlCenterLeft.add(pnlDatPhong, 1);
    } else if (e.getSource() == btnChuyenPhong) {
      if (pnlDatPhong != null) {
        pnlCenterLeft.remove(pnlDatPhong);
        pnlDatPhong.removeAll();
      }
      ChuyenPhong();
      pnlCenterLeft.add(pnlChuyenPhong, 1);
      if (pnlSuaPhong != null) {
        pnlCenterLeft.remove(pnlSuaPhong);
        pnlSuaPhong.removeAll();
      }

    } else if (e.getSource() == btnSuaDatPhong) {
      flagPhong = true;
      if (pnlDatPhong != null) {
        pnlCenterLeft.remove(pnlDatPhong);
        pnlDatPhong.removeAll();
      }
      if (pnlChuyenPhong != null) {
        pnlCenterLeft.remove(pnlChuyenPhong);
        pnlChuyenPhong.removeAll();
      }
      SuaPhong();
      pnlCenterLeft.add(pnlSuaPhong, 1);
    } else if (e.getSource() == btnDatPhongNhanh) {
      try {
        List<Phong> dsPhongThuong = new ArrayList<>();
        datPhongService.dsPhongThuong().forEach((phong) -> {
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
            dsPhongThuong.add(phong);
          }
        });
        List<Phong> dsPhongVip = new ArrayList<>();
        datPhongService.dsPhongVIP().forEach((phong) -> {
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
            dsPhongVip.add(phong);
          }
        });
        new ModelDangKy(dsPhongVip, dsPhongThuong, nhanVien).setVisible(true);
      } catch (MalformedURLException e1) {
        e1.printStackTrace();
      }
    } else if (e.getSource() == btnThanhToanNhanh) {
      try {
        new ThanhToanHoaDon(nhanVien).setVisible(true);
      } catch (MalformedURLException e1) {
        e1.printStackTrace();
      }
    } else if (e.getSource() == btnCfChuyenPhong) {
      String phongCu = (String) cmbPhongCanChuyen.getSelectedItem();
      String phongMoi = (String) cmbPhongChuyenToi.getSelectedItem();
      TrangThaiPhongEnum trangThaiPhong = null;

      for (Phong phong : phongService.dsPhong()) {
        if (phong.getTenPhong().trim().equals(phongMoi)) {
          maPhongMoi = phong.getMaPhong();
          break;
        }
      }
      for (Phong phong : phongService.dsPhong()) {
        if (phong.getTenPhong().trim().equals(phongCu)) {
          maPhongCu = phong.getMaPhong();
          trangThaiPhong = phong.getTtPhong();
          break;
        }
      }
      DatPhongDao datPhongDao = new DatPhongDao();
      boolean rs = true;
      boolean rs1 = datPhongDao.updatePhongCu(maPhongCu, "TRONG");
      boolean rs2 = datPhongDao.updatePhongMoi(maPhongMoi, trangThaiPhong.name());
      if (trangThaiPhong.name() != "DAT_TRUOC") {
        rs = datPhongDao.chuyenPhong(maPhongCu, maPhongMoi);
      }
      if (rs && rs1 && rs2) {
        if (loaiPhongcu.startsWith("T")) {
          dfModelPhongCanChuyen.removeElement(phongCu);
          dfModelPhongCanChuyen.addElement(phongMoi);
          dfModelPhongChuyenToi.removeElement(phongMoi);
          dfModelPhongChuyenToi.addElement(phongCu);
        } else {
          dfModelPhongCanChuyen.removeElement(phongCu);
          dfModelPhongCanChuyen.addElement(phongMoi);
          dfModelPhongChuyenToi.removeElement(phongMoi);
          dfModelPhongChuyenToi.addElement(phongCu);
        }
        for (int index = 0; index < tblPhongCho.getRowCount(); index++) {
          if (tblPhongCho.getValueAt(index, 2).toString().equals(phongCu)
              && tblPhongCho.getValueAt(index, 3).toString().equals(loaiPhongcu)) {
            tblPhongCho.setValueAt(phongMoi, index, 2);
            tblPhongCho.setValueAt(loaiPhongMoi, index, 3);
            break;
          }
        }
        pnlSubDanhSachPhong.removeAll();
        if (btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
          danhSachPhong(datPhongService.dsPhongThuong(), index);
          pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
        } else {
          danhSachPhong(datPhongService.dsPhongVIP(), index);
          pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
        }
        modelPhongCho.setRowCount(0);
        datPhongService.dsPhongDatTruoc();
        dynamicPhongCho(datPhongService.dsPhongDatTruoc(), null);
        lblKhachHangCanChuyen.setText("");
      }
    } else if (e.getSource() == btnXacNhanSuaPhong) {
      String value = (String) cmbPhong.getSelectedItem();
      for (Phong phong : phongService.dsPhong()) {
        if (phong.getTenPhong().trim().equals(value)) {
          maPhong = phong.getMaPhong();
          break;
        }
      }
      String loaiPhong = (String) cmbLoaiPhong.getSelectedItem();
      String tenPhong = (String) cmbPhong.getSelectedItem();
      String gioNhan = (String) cmbGioDat.getSelectedItem();
      int sucChua = Integer.parseInt(txtSucChua.getText());
      double giaPhong = Double.parseDouble(txtgiaPhong.getText());

      phong = new Phong(maPhong, tenPhong, giaPhong, sucChua, TrangThaiPhongEnum.DAT_TRUOC,
          loaiPhong == "VIP" ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG);

      SimpleDateFormat formatterGio = new SimpleDateFormat("dd/MM/yyyy HH:mm");
      SimpleDateFormat formatterNgay = new SimpleDateFormat("dd/MM/yyyy");

      Date gioNhanPhong = null;
      datPhong = new DatPhong();

      String ngayDat = generator.parseLocalDateToDate(ngayDatDatPhong.getDate().toString());
      Date ngayDatPhong = null;

      try {
        ngayDatPhong = formatterNgay.parse(ngayDat);
        gioNhanPhong = formatterGio.parse(ngayDat + " " + gioNhan);
        datPhong.setMaDP(maSuaDatPhong);
        datPhong.setngayDatPhong(ngayDatPhong);
        datPhong.setGioNhanPhong(gioNhanPhong);
        datPhong.setKhachHang(khachHang);
        datPhong.setPhong(phong);
        datPhong.setNhanVien(nhanVien);
        if (datPhongService.suaPhong(datPhong)) {
          JOptionPane.showMessageDialog(null, "Sửa phòng đặt thành công", "Thông báo",
              JOptionPane.INFORMATION_MESSAGE);
          phongService.dsPhong();
          pnlSubDanhSachPhong.removeAll();
          datPhongService.dsPhongDatTruoc();
          loadData(phong.getLoaiPhong().name());
          modelPhongCho.setRowCount(0);
          datPhongService.dsPhongDatTruoc();
          dynamicPhongCho(datPhongService.dsPhongDatTruoc(), null);
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtTenKH.setText("");
          txtSdt.setText("");
          txtLoaiTV.setText("");
          txaDiachi.setText("");
          cmbGioDat.removeItem(gioNhan);

          if (ngayDatPhong.compareTo(new Date()) < 0) {
            ngayDatDatPhong.setDate(new Date().toInstant().atZone(ZoneId.systemDefault()).toLocalDate());
          }
        }
      } catch (Exception e1) {
        e1.printStackTrace();
      }
    } else if (e.getSource() == cmbLoaiPhongCanChuyen) {
      String value = cmbLoaiPhongCanChuyen.getSelectedItem().toString();
      loaiPhongcu = value;
      if (value.equals("VIP")) {
        cmbPhongCanChuyen.setEnabled(true);
        cmbPhongCanChuyen.removeAllItems();
        cmbPhongCanChuyen.addItem("Chọn phòng");
        for (Phong phong : datPhongService.dsPhongVIP()) {
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)
              || phong.getTtPhong().equals(TrangThaiPhongEnum.DAT_TRUOC)) {
            dfModelPhongCanChuyen.addElement(phong.getTenPhong().trim());
          }
        }

        int countNew = dfModelPhongCanChuyen.getSize();
        if (countNew == 0) {
          dfModelPhongCanChuyen.addElement(HET_PHONG);
        }
        lblSucChuaCanChuyen.setText("25");
        lblGiaPhongCanChuyen.setText("500000");

      } else {
        cmbPhongCanChuyen.setEnabled(true);
        cmbPhongCanChuyen.removeAllItems();
        cmbPhongCanChuyen.addItem("Chọn phòng");
        for (Phong phong : datPhongService.dsPhongThuong()) {
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)
              || phong.getTtPhong().equals(TrangThaiPhongEnum.DAT_TRUOC)) {
            dfModelPhongCanChuyen.addElement(phong.getTenPhong().trim());
          }
        }

        int countNew = dfModelPhongCanChuyen.getSize();
        if (countNew == 0) {
          dfModelPhongCanChuyen.addElement(HET_PHONG);
        }
        lblSucChuaCanChuyen.setText("20");
        lblGiaPhongCanChuyen.setText("200000");
      }
    } else if (e.getSource() == cmbLoaiPhongChuyenToi) {
      cmbPhongChuyenToi.setEnabled(true);
      String loaiPhong = (String) cmbLoaiPhongChuyenToi.getSelectedItem();
      loaiPhongMoi = loaiPhong;
      if (loaiPhong.equals("VIP")) {
        dfModelPhongChuyenToi.removeAllElements();
        for (Phong phong : datPhongService.dsPhongVIP()) {
          if (!phong.getTenPhong().equals(tenPhongCu)) {

            if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
              dfModelPhongChuyenToi.addElement(phong.getTenPhong().trim());
            }
          }
        }

        int count = dfModelPhongChuyenToi.getSize();
        if (count == 0) {
          dfModelPhongChuyenToi.addElement(HET_PHONG);
        }
        lblSucChuaChuyenToi.setText("25");
        lblGiaPhongChuyenToi.setText("500000");
      } else {
        dfModelPhongChuyenToi.removeAllElements();
        for (Phong phong : datPhongService.dsPhongThuong()) {
          if (!phong.getTenPhong().equals(tenPhongCu)) {
            if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
              dfModelPhongChuyenToi.addElement(phong.getTenPhong().trim());
            }
          }
        }
        int count = dfModelPhongChuyenToi.getSize();
        if (count == 0) {
          dfModelPhongChuyenToi.addElement(HET_PHONG);
        }
        lblSucChuaChuyenToi.setText("20");
        lblGiaPhongChuyenToi.setText("200000");

      }
    } else if (e.getSource() == cmbPhongCanChuyen) {
      if (cmbPhongCanChuyen.getSelectedIndex() > 0) {
        String chuyen = cmbPhongCanChuyen.getSelectedItem().toString();
        for (Phong phong : phongService.dsPhong()) {
          if (phong.getTenPhong().trim().equals(chuyen)) {
            maPhong = phong.getMaPhong();
            break;
          }
        }
        KhachHang kh = datPhongService.getKH(maPhong);
        if (kh != null) {
          lblKhachHangCanChuyen.setText(kh.getTenKH());
        }
        if (datPhongService.dsDichVuTheoTen(maPhong).size() != 0) {
          dynamicThongTinDichVu(datPhongService.dsDichVuTheoTen(maPhong));
        } else {
          modelDichVu.setRowCount(0);
        }
      }
    } else if (e.getSource() == cmbPhong) {
      if (cmbPhong.getSelectedIndex() > 0) {
        cmbGioDat.removeAllItems();
        cmbGioDat.setEnabled(true);
        dfModelGioDat.addElement("Chọn giờ");
        for (int i = 8; i <= 22; i += 2) {
          if (i < 10) {
            dfModelGioDat.addElement("0" + i + ":00");
          } else {
            dfModelGioDat.addElement(i + ":00");
          }
        }
        LocalDate date = LocalDate.now();

        if (ngayDat == null || ngayDat.toString().equals(date.toString())) {
          LocalTime time = LocalTime.now();
          int hour = time.getHour();
          List<String> gioDats = new ArrayList<>();
          for (int i = 0; i < dfModelGioDat.getSize(); i++) {
            gioDats.add(dfModelGioDat.getElementAt(i));
          }
          for (String item : gioDats) {
            if (item.equals("Chọn giờ")) {
              continue;
            }
            String gio = item;
            String[] gioDat = gio.split(":");
            int gioDatInt = Integer.parseInt(gioDat[0]);
            if (hour - gioDatInt >= 0) {
              dfModelGioDat.removeElement(item);
            }
          }

          if (dfModelGioDat.getSize() == 1) {
            dfModelGioDat.removeAllElements();
            dfModelGioDat.addElement("Hết giờ đặt");
          }

          String value = cmbPhong.getSelectedItem().toString();
          for (Phong phong : phongService.dsPhong()) {
            if (phong.getTenPhong().trim().equals(value)) {
              maPhong = phong.getMaPhong();
              break;
            }
          }

          String ngayDatPhong = ngayDat != null ? ngayDat : ngayDatDatPhong.getDate().toString();
          List<DatPhong> listDatPhong = datPhongService
              .dsNgayDat(ngayDatPhong);
          for (int i = 0; i < listDatPhong.size(); i++) {
            if (listDatPhong.get(i).getPhong().getMaPhong().equals(maPhong)) {
              String gioDat = new SimpleDateFormat("HH:mm")
                  .format(datPhongService.dsNgayDat(ngayDatPhong).get(i).getGioNhanPhong());
              for (int j = 0; j < dfModelGioDat.getSize(); j++) {
                if (gioDat.equals(dfModelGioDat.getElementAt(j))) {
                  cmbGioDat.removeItemAt(j);
                }
              }
            }
          }
        }
      }
    } else if (e.getSource() == cmbLoaiPhong) {
      if (pnlDatPhong.getComponentCount() > 0) {
        String value = cmbLoaiPhong.getSelectedItem().toString();
        if (value.equals("VIP")) {
          dfModelPhong.removeAllElements();
          dfModelPhong.addElement("Chọn phòng");
          for (Phong phong : datPhongService.dsPhongVIP()) {
            if (ngayDat == null) {
              if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
                if (phong.getSoLanDatTruoc() < 8)
                  dfModelPhong.addElement(phong.getTenPhong().trim());
              }
            } else {
              if (phong.getSoLanDatTruoc() < 8)
                dfModelPhong.addElement(phong.getTenPhong().trim());
            }
          }
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtSucChua.setText("25");
          txtgiaPhong.setText("500000");

        } else {
          dfModelPhong.removeAllElements();
          dfModelPhong.addElement("Chọn phòng");
          for (Phong phong : datPhongService.dsPhongThuong()) {
            if (ngayDat == null) {
              if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
                if (phong.getSoLanDatTruoc() < 8)
                  dfModelPhong.addElement(phong.getTenPhong().trim());
              }
            } else {
              if (phong.getSoLanDatTruoc() < 8)
                dfModelPhong.addElement(phong.getTenPhong().trim());

            }
          }
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtSucChua.setText("20");
          txtgiaPhong.setText("200000");
        }
      } else if (pnlSuaPhong.getComponentCount() > 0) {
        String value = cmbLoaiPhong.getSelectedItem().toString();
        if (value.equals("VIP")) {
          dfModelPhong.removeAllElements();
          datPhongService.dsPhongDatTruoc().forEach((phong) -> {
            if (generator.convertLoaiPhongToString(phong.getPhong().getLoaiPhong()).equals(value))
              dfModelPhong.addElement(phong.getPhong().getTenPhong().trim());
          });
          dfModelPhong.addElement("Chọn phòng");

          datPhongService.dsPhongVIP().forEach((phong) -> {
            if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
              dfModelPhong.addElement(phong.getTenPhong().trim());
            }
          });
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtSucChua.setText("25");
          txtgiaPhong.setText("500000");

        } else {
          dfModelPhong.removeAllElements();
          datPhongService.dsPhongDatTruoc().forEach((phong) -> {
            if (generator.convertLoaiPhongToString(phong.getPhong().getLoaiPhong()).equals(value))
              dfModelPhong.addElement(phong.getPhong().getTenPhong().trim());
          });
          dfModelPhong.addElement("Chọn phòng");

          datPhongService.dsPhongThuong().forEach((phong) -> {
            if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
              dfModelPhong.addElement(phong.getTenPhong().trim());
            }
          });
          int count = dfModelPhong.getSize();
          if (count == 0) {
            dfModelPhong.addElement(HET_PHONG);
          }
          txtSucChua.setText("20");
          txtgiaPhong.setText("200000");
        }
      }
    } else if (e.getSource() == txtSdt) {
      String sdt = txtSdt.getText();
      if (!sdt.matches("\\d{10}+")) {
        JOptionPane.showMessageDialog(null, "Số điện thoại không hợp lệ", "Cảnh báo",
            JOptionPane.ERROR_MESSAGE);
        txtSdt.requestFocus();
        txtTenKH.setText("");
        txaDiachi.setText("");
        txtLoaiTV.setText("");

      } else {
        khachHang = khService.timKhachHang(sdt);
        if (khachHang != null) {
          if (pnlDatPhong.getComponentCount() > 0) {
            txtLoaiTV.setText(khachHang.getLoaiTV().getTenLoaiTV());
            txtTenKH.setText(khachHang.getTenKH());
            txaDiachi.setText(khachHang.getDiaChi());
            if (khachHang.getGioiTinh()) {
              chkGioiTinh.setSelected(true);
            }
          } else if (pnlSuaPhong.getComponentCount() > 0) {
            modelPhongCho.setRowCount(0);
            for (DatPhong dp : datPhongService.dsPhongDatTruoc()) {
              if (dp.getKhachHang().getMaKH().equals(khachHang.getMaKH())) {
                maSuaDatPhong = dp.getMaDP();
                txtLoaiTV.setText(khachHang.getLoaiTV().getTenLoaiTV());
                txtTenKH.setText(khachHang.getTenKH());
                txaDiachi.setText(khachHang.getDiaChi());
                if (khachHang.getGioiTinh()) {
                  chkGioiTinh.setSelected(true);
                }
                String gioDat = new SimpleDateFormat("HH:mm").format(dp.getGioNhanPhong());
                String ngayDat = new SimpleDateFormat("dd/MM/yyyy").format(dp.getngayDatPhong());
                modelPhongCho.addRow(
                    new Object[] { dp.getKhachHang().getTenKH().trim(),
                        dp.getKhachHang().getLoaiTV().getTenLoaiTV().trim(),
                        dp.getPhong().getTenPhong().trim(),
                        dp.getPhong().getLoaiPhong().getLoaiPhong(), ngayDat, gioDat,
                        button.getText(),
                        dp.getMaDP(), dp.getKhachHang().getMaKH(), dp.getPhong().getMaPhong(),
                        dp.getPhong().getSucChua(), dp.getPhong().getgiaPhong() });
              }
            }
          }
        } else {
          int thongBao = JOptionPane.showConfirmDialog(null, "Khách hàng không tồn tại. Thêm khách hàng mới",
              "Thông báo", JOptionPane.YES_NO_OPTION);
          if (thongBao == JOptionPane.YES_OPTION) {
            try {
              new QuanLyKhachHang(tk, sdt).setVisible(true);
            } catch (MalformedURLException e1) {
              e1.printStackTrace();
            }
          }
        }
      }
    }
    if (flag) {
      if (e.getSource() == btnNext) {
        if (!btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
          if (checkCounter < datPhongService.dsPhongVIP().size()) {
            index += 12;
            pnlSubDanhSachPhong.removeAll();
            danhSachPhong(datPhongService.dsPhongVIP(), index);
          }
        } else {
          if (checkCounter < datPhongService.dsPhongThuong().size()) {
            index += 12;
            pnlSubDanhSachPhong.removeAll();
            danhSachPhong(datPhongService.dsPhongThuong(), index);
          }
        }
        checkCounter += 12;
        if (checkCounter >= datPhongService.dsPhongVIP().size()) {
          btnNext.setEnabled(false);
        }
        btnPre.setEnabled(true);
      } else if (e.getSource() == btnPre) {
        if (!btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
          if (checkCounter > 12) {
            index -= 12;
            pnlSubDanhSachPhong.removeAll();
            danhSachPhong(datPhongService.dsPhongVIP(), index);

          }
        } else {
          if (checkCounter > 12) {
            index -= 12;
            pnlSubDanhSachPhong.removeAll();
            danhSachPhong(datPhongService.dsPhongThuong(), index);
          }
        }
        checkCounter -= 12;
        if (checkCounter <= 12) {
          btnPre.setEnabled(false);
        }
        if (checkCounter < datPhongService.dsPhongVIP().size()) {
          btnNext.setEnabled(true);
        }
      }

    }
    // filter phòng

    if (e.getSource() == btnRefresh) {
      pnlSubDanhSachPhong.removeAll();
      if (btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
        danhSachPhong(datPhongService.dsPhongThuong(), index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      } else {
        danhSachPhong(datPhongService.dsPhongVIP(), index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      }
      cmbPhong.setSelectedIndex(0);
      cmbGioDat.removeAllItems();
      dfModelGioDat.addElement("Chọn giờ");
      cmbGioDat.setEnabled(false);
      modelPhongCho.setRowCount(0);
      dynamicPhongCho(datPhongService.dsPhongDatTruoc(), null);
    } else if (e.getSource() == btnPhongVIP) {
      flag = true;

      pnlSubDanhSachPhong.removeAll();
      modelPhongCho.setRowCount(0);
      if (btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
        btnPhongVIP.setText("Phòng thường (F7)");
        danhSachPhong(datPhongService.dsPhongVIP(), index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
        dynamicPhongCho(datPhongService.dsPhongDatTruoc(), "VIP");
      } else {
        btnPhongVIP.setText("Phòng VIP (F7)");
        danhSachPhong(datPhongService.dsPhongThuong(), index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
        dynamicPhongCho(datPhongService.dsPhongDatTruoc(), "Thường");
      }
    } else if (e.getSource() == btnMauHoatDong) {
      flag = false;
      pnlSubDanhSachPhong.removeAll();

      index = 0;
      if (!btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
        danhSachPhongFilter(datPhongService.dsPhongVIP(), TrangThaiPhongEnum.HOAT_DONG, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      } else {
        danhSachPhongFilter(datPhongService.dsPhongThuong(), TrangThaiPhongEnum.HOAT_DONG, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      }
    } else if (e.getSource() == btnMauTrong) {
      flag = false;
      pnlSubDanhSachPhong.removeAll();
      index = 0;
      if (!btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
        danhSachPhongFilter(datPhongService.dsPhongVIP(), TrangThaiPhongEnum.TRONG, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      } else {
        danhSachPhongFilter(datPhongService.dsPhongThuong(), TrangThaiPhongEnum.TRONG, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      }
    } else if (e.getSource() == btnMauDatTruoc) {
      flag = false;
      pnlSubDanhSachPhong.removeAll();
      index = 0;
      if (!btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
        danhSachPhongFilter(datPhongService.dsPhongVIP(), TrangThaiPhongEnum.DAT_TRUOC, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      } else {
        danhSachPhongFilter(datPhongService.dsPhongThuong(), TrangThaiPhongEnum.DAT_TRUOC, index);
        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
      }
    }
    int countPre = dfModelPhong.getSize();
    for (int i = 0; i < pnlSubDanhSachPhong.getComponentCount(); i++) {
      if (pnlSubDanhSachPhong.getComponent(i) instanceof JButton) {
        JButton btn = (JButton) pnlSubDanhSachPhong.getComponent(i);
        if (e.getSource() == btn) {
          for (int j = 0; j < btn.getComponentCount(); j++) {
            JLabel lbl = (JLabel) btn.getComponent(j);
            for (Phong p : phongService.dsPhong()) {
              if (p.getTenPhong().trim().equals(lbl.getText())) {
                if (p.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
                  int thongbao = JOptionPane.showConfirmDialog(null, "Bắt đầu sử dụng phòng này",
                      "Thông báo", JOptionPane.YES_NO_OPTION);
                  if (thongbao == JOptionPane.YES_OPTION) {
                    phongService.updateStatus(p.getMaPhong(),
                        TrangThaiPhongEnum.HOAT_DONG.name());
                    dfModelPhong.addElement("Chọn phòng");
                    datPhongService.dsPhongThuong().forEach((phong) -> {
                      if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
                        if (phong.getSoLanDatTruoc() < 8)
                          dfModelPhong.addElement(phong.getTenPhong().trim());
                      }
                    });
                    if (countPre < dfModelPhong.getSize()) {
                      pnlSubDanhSachPhong.removeAll();
                      if (btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
                        danhSachPhong(datPhongService.dsPhongThuong(), index);
                        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
                      } else {
                        danhSachPhong(datPhongService.dsPhongVIP(), index);
                        pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
                      }
                      String maHoaDong = generator.tuTaoMaHoaDon(p.getMaPhong(), nhanVien.getMaNV());
                      HoaDon hd = new HoaDon(maHoaDong, LocalDateTime.now());
                      hd.setNhanVien(nhanVien);
                      hoaDonService.themHoaDon(hd);
                      ChiTietHoaDon cthd = new ChiTietHoaDon();
                      cthd.setPhong(p);
                      hoaDonService.themChiTietHD(cthd, maHoaDong);
                      try {
                        new PhongHoatDong(lbl.getText(), p.getMaPhong(),
                            nhanVien, null, maHoaDong).setVisible(true);
                      } catch (MalformedURLException e1) {
                        e1.printStackTrace();
                      }
                      break;
                    }
                  }
                } else if (p.getTtPhong().equals(TrangThaiPhongEnum.DAT_TRUOC)) {
                  for (DatPhong dp : datPhongService.dsPhongDatTruoc()) {
                    if (dp.getPhong().getMaPhong().equals(p.getMaPhong())) {
                      try {
                        new PhongDatTruoc(dp, nhanVien, tk).setVisible(true);
                      } catch (MalformedURLException e1) {
                        e1.printStackTrace();
                      }
                      break;
                    }
                  }
                } else {
                  KhachHang kh = null;
                  String mahd = hoaDonService.getMaHoaDonByPhong(p.getMaPhong(), nhanVien.getMaNV());
                  for (HoaDon hd : hoaDonService.dsHD()) {
                    if (hd.getMaHD().trim().equals(mahd)) {
                      if (hd.getKhachHang() != null) {
                        String makh = hd.getKhachHang().getMaKH();
                        if (makh != null)
                          kh = khService.timKhachHang(makh);
                      }
                    }
                  }
                  try {
                    new PhongHoatDong(lbl.getText(), p.getMaPhong(), nhanVien,
                        kh, mahd).setVisible(true);
                  } catch (MalformedURLException e1) {
                    e1.printStackTrace();
                  }
                  break;
                }
              }

            }
          }
        }
      }
    }
  }

  private void loadData(String loaiPhong) {
    if (!loaiPhong.startsWith("VIP")) {
      phongService.dsPhong();
      if (dfModelPhong != null) {
        dfModelPhong.removeAllElements();
        dfModelPhong.addElement("Chọn phòng");

        for (Phong phong : datPhongService.dsPhongThuong()) {
          if (!phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)) {
            if (phong.getSoLanDatTruoc() < 8)
              dfModelPhong.addElement(phong.getTenPhong().trim());
          }
        }
      } else {
        dfModelPhongCanChuyen.removeAllElements();
        dfModelPhongChuyenToi.removeAllElements();
        for (Phong phong : datPhongService.dsPhongThuong()) {
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.TRONG)) {
            dfModelPhongChuyenToi.addElement(phong.getTenPhong().trim());
          }
          if (phong.getTtPhong().equals(TrangThaiPhongEnum.HOAT_DONG)
              && phong.getTtPhong().equals(TrangThaiPhongEnum.DAT_TRUOC)) {
            dfModelPhongCanChuyen.addElement(phong.getTenPhong().trim());
          }
        }
      }
    }
    if (btnPhongVIP.getText().equals("Phòng VIP (F7)")) {
      danhSachPhong(datPhongService.dsPhongThuong(), index);
      pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
    } else {
      danhSachPhong(datPhongService.dsPhongVIP(), index);
      pnlDanhSachPhong.add(pnlSubDanhSachPhong, Integer.valueOf(1));
    }

  }

  @Override
  public void mouseClicked(MouseEvent arg0) {
    Object o = arg0.getComponent();
    if (o.equals(tblPhongCho)) {
      if (flagPhong == true && khachHang != null) {
        int row = tblPhongCho.getSelectedRow();
        dfModelPhong.setSelectedItem(tblPhongCho.getValueAt(row, 2));
        dfModelLoaiPhong.setSelectedItem(
            (tblPhongCho.getValueAt(row, 3).toString()));
        txtSucChua.setText(String.valueOf(tblPhongCho.getValueAt(row, 10)));
        txtgiaPhong.setText(String.valueOf(tblPhongCho.getValueAt(row, 11)));
        ngayDatDatPhong.setText(generator.parseLocaldateToDatetimepicker(
            tblPhongCho.getValueAt(row, 4).toString()));
        dfModelGioDat.setSelectedItem(
            (tblPhongCho.getValueAt(row, 5).toString()));
      }
    }
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
