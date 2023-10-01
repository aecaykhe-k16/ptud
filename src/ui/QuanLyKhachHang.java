package ui;

import java.awt.BorderLayout;
import java.awt.Color;
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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.KeyStroke;
import javax.swing.Timer;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import bus.IDangNhapService;
import bus.IPhanCongCaLamService;
import bus.implement.DangNhapImp;
import bus.implement.KhachHangImp;
import bus.implement.PhanCongCaLamImp;
import entities.KhachHang;
import entities.LoaiThanhVien;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.ReadJSONDiaChi;
import util.Generator;
import util.MyButton;
import util.PlaceholderTextField;
import util.RoundedBorderWithColor;
import util.SpecialButton;

public class QuanLyKhachHang extends JFrame implements ActionListener, MouseListener {
  private JLabel lblIconLogo, lblTitle, lblDanhSachCaLam;

  private JPanel pnlMenu, pnlTop, pnInfo, pnlBtn, pnlFilter, pnlCenter, pnlMainUI;
  private JLabel lblBoLoc, lblQuanLyDatPhong, lblHoaDon;
  private MyButton btnThemKH, btnSuaKH, btnXoaKH, btnTimkiemKH, btnXoaTrangKH, btnFilter;
  private PlaceholderTextField txtTimkiemKH;

  private DefaultComboBoxModel<String> dfBoxModelGioiTinh, dfBoxModelvitri;
  private JComboBox<String> cmbGioiTinhFilter, cmbLoaiThanhVien, cmbGioiTinh;
  private JTable tblKhachHang;
  private DefaultTableModel tableModelKH;
  private JButton btnNhanVien, btnPhong, btnKhachHang, btnThongke,
      btnPhanCong, btnTroGiup, btnIconUser, btnIconLogout, btnRefresh, btnHoaDon, btnQuanLyDatPhong,
      btnDichVu;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong, lblDichVu;
  JLayeredPane layeredPane;
  boolean flag = false;

  private Cursor handCursor = new Cursor(Cursor.HAND_CURSOR);

  private JLabel lblTenKH, lblSdt, lblGioiTinh, lblSoDinhDanh, lbllocgioitinh, lbllocthanhvien;

  private JTextField txtTenKH, txtSdt, txtSoDinhDanh;
  private JLabel lblTinh, lblHuyen, lblXa;
  private DefaultComboBoxModel<String> modelTinh, modelHuyen, modelXa;
  private JComboBox<String> cmbTinh, cmbHuyen, cmbXa;
  private ReadJSONDiaChi data = new ReadJSONDiaChi();
  private List<String> dsTinh = data.getDSTinh();
  // function
  private Generator generator = new Generator();
  private TaiKhoan tk;
  KhachHangImp khachHangService = new KhachHangImp();
  private IDangNhapService dangNhap = new DangNhapImp();
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private String sdt;

  public QuanLyKhachHang(TaiKhoan taiKhoan, String sdt) throws MalformedURLException {
    this.sdt = sdt;
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;
    setTitle(Constants.APP_NAME);
    setExtendedState(MAXIMIZED_BOTH);
    setMinimumSize(new Dimension(1500, 800));
    this.setIconImage(imageIcon);
    setDefaultCloseOperation(EXIT_ON_CLOSE);
    setLocationRelativeTo(null);
    this.setBackground(Color.WHITE);
    setLayout(null);
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 2000, 1500);
    add(layeredPane);
    MainUI();

    // keybinding
    btnThemKH.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnThem");
    btnThemKH.getActionMap().put("btnThem", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnThemKH.doClick();
      }
    });

    btnSuaKH.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F2, 0),
        "btnSua");
    btnSuaKH.getActionMap().put("btnSua", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnSuaKH.doClick();
      }
    });
    btnXoaTrangKH.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F4, 0),
        "btnXoaTrang");
    btnXoaTrangKH.getActionMap().put("btnXoaTrang", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnXoaTrangKH.doClick();
      }
    });

    btnXoaKH.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F3, 0),
        "btnXoa");
    btnXoaKH.getActionMap().put("btnXoa", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnXoaKH.doClick();
      }
    });
    btnTimkiemKH.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnTimkiemKH");
    btnTimkiemKH.getActionMap().put("btnTimkiemKH", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimkiemKH.doClick();
      }
    });
  }

  private void MainUI() {
    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 2000, 1400);
    pnlTop();
    PnlMenu();
    PnlCenter();
    PnlTable();

    layeredPane.add(pnlMainUI, Integer.valueOf(1));
    tblKhachHang.addMouseListener(this);
    btnXoaTrangKH.addActionListener(this);
    unlockTextFields(false);
    if (!sdt.equals("")) {
      btnSuaKH.setText("Huỷ (F2)");
      btnThemKH.setText("Lưu (F1)");
      btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
      btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
      txtTenKH.requestFocus();
      unlockTextFields(true);
    }
  }

  void PnlTable() {
    JPanel pnBang = new JPanel();
    pnBang.setLayout(new BorderLayout());

    String[] header = { "Mã KH", "Họ Tên", "Số điện thoại", "Giới Tính ",
        "Địa chỉ", "Loại thành viên", "Số định danh" };
    tableModelKH = new DefaultTableModel(header, 0);
    tblKhachHang = new JTable(tableModelKH);
    tblKhachHang.setRowHeight(25);
    JScrollPane scrollPane = new JScrollPane(tblKhachHang);
    pnBang.add(scrollPane);
    pnBang.setBounds(10, 405, 1520, 380);
    tblKhachHang.setDefaultEditor(Object.class, null);
    pnlMainUI.add(pnBang);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    tblKhachHang.getColumnModel().getColumn(0).setMinWidth(100);
    tblKhachHang.getColumnModel().getColumn(0).setMaxWidth(100);
    tblKhachHang.getColumnModel().getColumn(1).setMinWidth(200);
    tblKhachHang.getColumnModel().getColumn(1).setMaxWidth(200);
    tblKhachHang.getColumnModel().getColumn(2).setMinWidth(130);
    tblKhachHang.getColumnModel().getColumn(2).setMaxWidth(130);
    tblKhachHang.getColumnModel().getColumn(3).setMinWidth(100);
    tblKhachHang.getColumnModel().getColumn(3).setMaxWidth(100);
    tblKhachHang.getColumnModel().getColumn(5).setMinWidth(170);
    tblKhachHang.getColumnModel().getColumn(5).setMaxWidth(170);
    tblKhachHang.getColumnModel().getColumn(6).setMinWidth(150);
    tblKhachHang.getColumnModel().getColumn(6).setMaxWidth(150);
    tblKhachHang.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(1).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(2).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(3).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(4).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(5).setCellRenderer(centerRenderer);
    tblKhachHang.getColumnModel().getColumn(6).setCellRenderer(centerRenderer);
    loadTable();
  }

  void PnlCenter() {
    pnlCenter = new JPanel();
    pnlCenter.setBounds(0, 150, 1800, 250);
    pnlCenter.setLayout(null);
    pnlBtn = new JPanel();
    pnlBtn.setLayout(null);
    pnlBtn.setBounds(1180, 30, 250, 170);

    Font fontbtn = new Font("Arial", Font.PLAIN, 15);

    btnThemKH = new MyButton(20, Color.decode("#7ED957"), new Color(238, 238, 238));
    btnThemKH.setBounds(0, 0, 250, 40);
    btnThemKH.setText("Thêm (F1)");
    btnThemKH.setFocusable(false);
    btnThemKH.setBorderPainted(false);
    btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
    btnThemKH.setFont(fontbtn);
    btnThemKH.setCursor(handCursor);
    pnlBtn.add(btnThemKH);

    btnSuaKH = new MyButton(20, Color.decode("#FFDF2B"), new Color(238, 238, 238));
    btnSuaKH.setText("Sửa (F2)");
    btnSuaKH.setBounds(0, 40, 250, 40);
    btnSuaKH.setFocusable(false);
    btnSuaKH.setBorderPainted(false);
    btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
    btnSuaKH.setFont(fontbtn);
    btnSuaKH.setCursor(handCursor);
    pnlBtn.add(btnSuaKH);

    btnXoaKH = new MyButton(20, Color.WHITE, new Color(238, 238, 238));
    btnXoaKH.setText("Xoá (F3)");
    btnXoaKH.setBounds(0, 85, 250, 40);
    btnXoaKH.setFocusable(false);
    btnXoaKH.setBorderPainted(false);
    btnXoaKH.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    btnXoaKH.setFont(fontbtn);
    btnXoaKH.setCursor(handCursor);
    pnlBtn.add(btnXoaKH);

    btnXoaTrangKH = new MyButton(20, new Color(248, 249, 167), new Color(238, 238, 238));
    btnXoaTrangKH.setText("Xoá Trắng (F4)");
    btnXoaTrangKH.setFocusable(false);
    btnXoaTrangKH.setBorderPainted(false);
    btnXoaTrangKH.setBounds(0, 130, 250, 40);
    btnXoaTrangKH.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    btnXoaTrangKH.setFont(fontbtn);
    btnXoaTrangKH.setCursor(handCursor);
    pnlBtn.add(btnXoaTrangKH);

    pnlCenter.add(pnlBtn);

    pnlFilter = new JPanel();
    pnlFilter.setLayout(null);
    pnlFilter.setBounds(0, 200, 1850, 50);
    lblBoLoc = new JLabel("Bộ lọc");
    lblBoLoc.setForeground(Color.decode("#DC5E30"));
    lblBoLoc.setBounds(10, 0, 200, 40);
    lblBoLoc.setFont(new Font("Arial", Font.PLAIN, 20));
    pnlFilter.add(lblBoLoc);
    lbllocgioitinh = new JLabel("Giới Tính ");
    lbllocthanhvien = new JLabel("Loại Thành Viên ");
    pnlFilter.add(lbllocgioitinh);
    pnlFilter.add(lbllocthanhvien);
    lbllocgioitinh.setBounds(150, 2, 150, 40);
    lbllocgioitinh.setFont(new Font("Arial", Font.PLAIN, 17));
    lbllocthanhvien.setBounds(440, 2, 180, 40);
    lbllocthanhvien.setFont(new Font("Arial", Font.PLAIN, 17));

    pnlCenter.add(pnlFilter);

    btnFilter = new MyButton(20, Color.decode("#01C3CC"), new Color(238, 238, 238));
    btnFilter.setText("Lọc");
    btnFilter.setBounds(870, 5, 120, 30);
    btnFilter.setIcon(FontIcon.of(FontAwesomeSolid.FILTER, 20));
    btnFilter.setFont(new Font("Arial", Font.PLAIN, 16));
    btnFilter.setBorder(null);
    btnFilter.setFocusPainted(false);
    btnFilter.setBorderPainted(false);
    btnFilter.setCursor(handCursor);
    pnlFilter.add(btnFilter);

    btnTimkiemKH = new MyButton(20, Color.lightGray, new Color(238, 238, 238));
    btnTimkiemKH.setText("Tìm kiếm ");
    btnTimkiemKH.setBounds(1300, 5, 150, 30);
    btnTimkiemKH.setFocusable(false);
    btnTimkiemKH.setBorderPainted(false);
    btnTimkiemKH.setCursor(handCursor);
    btnTimkiemKH.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));
    btnTimkiemKH.setFont(fontbtn);
    pnlFilter.add(btnTimkiemKH);
    txtTimkiemKH = new PlaceholderTextField(Color.GRAY, false);
    txtTimkiemKH.setPlaceholder("Nhập tên khách hàng");
    txtTimkiemKH.setBounds(1030, 5, 250, 30);
    txtTimkiemKH.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    txtTimkiemKH.setFont(new Font("Arial", Font.PLAIN, 20));
    pnlFilter.add(txtTimkiemKH);

    btnRefresh = new JButton("");
    btnRefresh.setBounds(1460, 10, 30, 25);
    btnRefresh.setBackground(new Color(238, 238, 238));
    btnRefresh.setBorder(null);
    btnRefresh.setIcon(FontIcon.of(FontAwesomeSolid.REDO, 20));
    btnRefresh.setToolTipText("Refresh");
    btnRefresh.setCursor(handCursor);
    pnlFilter.add(btnRefresh);

    dfBoxModelGioiTinh = new DefaultComboBoxModel<String>();
    dfBoxModelGioiTinh.addElement("Nam");
    dfBoxModelGioiTinh.addElement("Nữ");
    dfBoxModelGioiTinh.addElement("Khác");
    cmbGioiTinhFilter = new JComboBox<String>(dfBoxModelGioiTinh);
    cmbGioiTinhFilter.setBounds(250, 7, 150, 30);
    cmbGioiTinhFilter.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 10));
    cmbGioiTinhFilter.setBackground(Color.decode("#ffffff"));
    cmbGioiTinhFilter.setFont(new Font("Arial", Font.PLAIN, 20));
    // cmbGioiTinhFilter.setBackground(Color.decode(mainColor));
    pnlFilter.add(cmbGioiTinhFilter);

    dfBoxModelvitri = new DefaultComboBoxModel<String>();
    dfBoxModelvitri.addElement("Thân Thiết");
    dfBoxModelvitri.addElement("Bạc");
    dfBoxModelvitri.addElement("Vàng");
    dfBoxModelvitri.addElement("Bạch Kim");
    dfBoxModelvitri.addElement("Kim Cương");
    cmbLoaiThanhVien = new JComboBox<String>(dfBoxModelvitri);
    cmbLoaiThanhVien.setBounds(600, 7, 250, 30);
    cmbLoaiThanhVien.setFont(new Font("Arial", Font.PLAIN, 20));
    cmbLoaiThanhVien.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 10));
    cmbLoaiThanhVien.setBackground(Color.decode("#ffffff"));
    pnlFilter.add(cmbLoaiThanhVien);

    /// giữa KH
    Font fonttxt = new Font("Arial", Font.PLAIN, 17);

    lblTenKH = new JLabel("Họ Tên KH ");
    lblTenKH.setBounds(110, 50, 150, 70);
    lblTenKH.setFont(fonttxt);
    lblTenKH.setBackground(Color.GREEN);

    txtTenKH = new JTextField();
    txtTenKH.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtTenKH.setBounds(230, 65, 200, 40);
    txtTenKH.setFont(fonttxt);

    lblSoDinhDanh = new JLabel("Số định danh ");
    lblSoDinhDanh.setBounds(110, 125, 120, 70);
    lblSoDinhDanh.setFont(fonttxt);

    txtSoDinhDanh = new JTextField();
    txtSoDinhDanh.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtSoDinhDanh.setBounds(230, 140, 200, 40);
    txtSoDinhDanh.setFont(fonttxt);

    lblSdt = new JLabel("Số điện thoại ");
    lblSdt.setBounds(450, 50, 140, 70);
    lblSdt.setFont(fonttxt);
    lblSdt.setBackground(Color.GREEN);

    txtSdt = new JTextField(sdt);
    txtSdt.setBounds(580, 65, 200, 40);
    txtSdt.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtSdt.setFont(fonttxt);

    lblGioiTinh = new JLabel("Giới Tính");
    lblGioiTinh.setBounds(450, 125, 100, 70);
    lblGioiTinh.setFont(fonttxt);

    dfBoxModelGioiTinh = new DefaultComboBoxModel<String>();
    dfBoxModelGioiTinh.addElement("Nam");
    dfBoxModelGioiTinh.addElement("Nữ");
    cmbGioiTinh = new JComboBox<String>(dfBoxModelGioiTinh);
    cmbGioiTinh.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 10));
    cmbGioiTinh.setBackground(Color.decode("#ffffff"));
    cmbGioiTinh.setFont(fonttxt);
    cmbGioiTinh.setBounds(580, 140, 200, 40);

    lblTinh = new JLabel("Tỉnh/Thành Phố");
    lblTinh.setBounds(800, 50, 200, 30);
    lblTinh.setFont(fonttxt);
    modelTinh = new DefaultComboBoxModel<>();
    modelTinh.addElement("Chọn tỉnh");
    for (String string : dsTinh) {
      modelTinh.addElement(string);
    }
    cmbTinh = new JComboBox<>(modelTinh);
    cmbTinh.setBounds(930, 50, 230, 30);

    lblHuyen = new JLabel("Huyện/Quận");
    lblHuyen.setBounds(800, 100, 200, 30);
    lblHuyen.setFont(fonttxt);
    modelHuyen = new DefaultComboBoxModel<>();
    modelHuyen.addElement("Chọn huyện");
    cmbHuyen = new JComboBox<>(modelHuyen);
    cmbHuyen.setBounds(930, 100, 230, 30);
    cmbHuyen.setEnabled(false);

    lblXa = new JLabel("Xã/Phường");
    lblXa.setBounds(800, 150, 200, 30);
    lblXa.setFont(fonttxt);
    modelXa = new DefaultComboBoxModel<>();
    modelXa.addElement("Chọn xã");
    cmbXa = new JComboBox<>(modelXa);
    cmbXa.setBounds(930, 150, 230, 30);
    cmbXa.setEnabled(false);

    pnlCenter.add(lblTenKH);
    pnlCenter.add(txtTenKH);
    pnlCenter.add(lblSdt);
    pnlCenter.add(txtSdt);
    pnlCenter.add(lblGioiTinh);
    pnlCenter.add(cmbGioiTinh);

    pnlCenter.add(lblTinh);
    pnlCenter.add(cmbTinh);
    pnlCenter.add(lblHuyen);
    pnlCenter.add(cmbHuyen);
    pnlCenter.add(lblXa);
    pnlCenter.add(cmbXa);

    pnlCenter.add(lblSoDinhDanh);
    pnlCenter.add(txtSoDinhDanh);
    pnlMainUI.add(pnlCenter);
    btnThemKH.addActionListener(this);
    btnSuaKH.addActionListener(this);
    btnXoaKH.addActionListener(this);
    btnTimkiemKH.addActionListener(this);
    btnRefresh.addActionListener(this);
    btnFilter.addActionListener(this);
    cmbTinh.addActionListener(this);
    cmbHuyen.addActionListener(this);
    cmbXa.addActionListener(this);
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
      btnNhanVien.setCursor(handCursor);
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
      btnPhong.setCursor(handCursor);
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
      btnKhachHang.setCursor(handCursor);
      btnKhachHang.setIcon(FontIcon.of(FontAwesomeSolid.USER_TIE, 30, Color.decode("#7743DB")));
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
      btnHoaDon.setCursor(handCursor);
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
      btnThongke.setCursor(handCursor);
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
      btnPhanCong.setCursor(handCursor);
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
      btnQuanLyDatPhong.setCursor(handCursor);
      btnQuanLyDatPhong.setIcon(FontIcon.of(FontAwesomeSolid.TH, 30));
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
      btnDichVu.setCursor(handCursor);
      btnDichVu.setIcon(FontIcon.of(FontAwesomeSolid.CONCIERGE_BELL, 30));
      btnDichVu.setFocusPainted(false);

      btnTroGiup = new MyButton(0, Color.decode(Constants.MAIN_COLOR), Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setText("Trợ giúp");
      btnTroGiup.setFont(f2);
      btnTroGiup.setBounds(1360, 0, 180, 50);
      btnTroGiup.setBorder(null);
      btnTroGiup.setBackground(Color.decode(Constants.MAIN_COLOR));
      btnTroGiup.setCursor(handCursor);
      btnTroGiup.setIcon(FontIcon.of(FontAwesomeSolid.QUESTION_CIRCLE, 30));
      btnTroGiup.setFocusPainted(false);
    } catch (Exception e) {
      e.printStackTrace();
    }
    if (dangNhap.getNV(tk.getEmail()).getQuanLy() == null) {
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

  void pnlTop() {
    pnlTop = new JPanel();
    pnlTop.setBounds(0, 0, 2000, 100);

    pnlTop.setBackground(Color.decode(Constants.TITLE_COLOR));

    pnlTop.setLayout(null);

    lblIconLogo = new JLabel();
    lblIconLogo.setBounds(50, 0, 150, 100);
    lblIconLogo.setIcon(new ImageIcon(imageIcon));

    lblTitle = new JLabel(Constants.TITLE);
    lblTitle.setBounds(470, 0, 750, 100);
    lblTitle.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 70));
    lblTitle.setForeground(Color.decode("#FFFFFFF"));

    pnInfo = new JPanel();
    pnInfo.setBounds(1300, 0, 250, 100);
    pnInfo.setBackground(Color.decode(Constants.TITLE_COLOR));
    pnInfo.setLayout(null);

    btnIconUser = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconUser.setText(dangNhap.getNV(tk.getEmail()).getTenNV());
    btnIconUser.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconUser.setBounds(0, 0, 250, 50);
    btnIconUser.setBorder(null);
    btnIconUser.setBackground(Color.decode(Constants.TITLE_COLOR));

    btnIconUser.setForeground(Color.WHITE);
    btnIconUser.setIcon(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE));
    btnIconUser.setBorderPainted(false);
    btnIconUser.setFocusPainted(false);

    // add btnIconLogout to pnInfo
    btnIconLogout = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setText(Constants.DANG_XUAT);

    btnIconLogout.setBounds(30, 50, 200, 50);
    btnIconLogout.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconLogout.setBorder(null);
    btnIconLogout.setBackground(Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setForeground(Color.WHITE);
    btnIconLogout.setIcon(FontIcon.of(FontAwesomeSolid.SIGN_OUT_ALT, 30, Color.RED));
    btnIconLogout.setBorderPainted(false);
    btnIconLogout.setFocusPainted(false);

    btnIconUser.setCursor(handCursor);
    btnIconLogout.setCursor(handCursor);

    lblDanhSachCaLam = new JLabel(caLamService.getCaTucTheoNV(tk.getEmail()));
    lblDanhSachCaLam.setBounds(1090, 70, 250, 20);
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

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    try {
      if (e.getSource() == btnPhong) {
        new QuanLyPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnNhanVien) {
        new QLNhanVien(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnThongke) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnPhanCong) {
        new PhanCongCaLam(tk).setVisible(true);
        this.dispose();
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
      } else if (e.getSource() == btnHoaDon) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnQuanLyDatPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      }
    } catch (Exception e1) {
      e1.printStackTrace();
    }
    if (e.getSource() == cmbTinh) {
      if (cmbTinh.getSelectedIndex() > 0) {
        cmbHuyen.setEnabled(true);
        modelHuyen.removeAllElements();
        modelHuyen.addElement("Chọn huyện");
        modelXa.removeAllElements();
        modelXa.addElement("Chọn xã");
        cmbXa.setEnabled(false);
        String tinhChon = (String) cmbTinh.getSelectedItem();
        List<String> dsHuyen = data.getDSHuyen(tinhChon);
        for (String string : dsHuyen) {
          modelHuyen.addElement(string);
        }
      }
    }
    if (e.getSource() == cmbHuyen) {
      if (cmbHuyen.getSelectedIndex() > 0) {
        cmbXa.setEnabled(true);
        modelXa.removeAllElements();
        modelXa.addElement("Chọn xã");
        String huyenChon = (String) cmbHuyen.getSelectedItem();
        List<String> dsXa = data.getDSXa(huyenChon);
        for (String string : dsXa) {
          modelXa.addElement(string);
        }
      }
    }
    if (e.getSource() == btnThemKH) {

      if (btnThemKH.getText().equals("Thêm (F1)")) {
        btnSuaKH.setText("Huỷ (F2)");
        btnThemKH.setText("Lưu (F1)");
        btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
        btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
        unlockTextFields(true);
      } else if (btnThemKH.getText().equals("Lưu (F1)")) {
        if (checkEmpty() == true) {
          String sdtKH = txtSdt.getText();
          String soDinhDanh = txtSoDinhDanh.getText();
          int kiemtraKH = khachHangService.kiemtraKH(sdtKH, soDinhDanh);
          if (!soDinhDanh.isEmpty()) {
            if (kiemtraKH == 1) {
              txtSdt.requestFocus();
              JOptionPane.showMessageDialog(this, "Số điện thoại phải bằng 10 số");
              return;
            } else if (kiemtraKH == 2) {
              txtSdt.requestFocus();
              JOptionPane.showMessageDialog(this, "Số định danh phải bằng 12 số");
              return;
            }
          }
          String maKH = txtSdt.getText().substring(6, 10);
          String tenKH = txtTenKH.getText();
          String gioitinhKH = cmbGioiTinh.getSelectedItem().toString();
          String tinh = cmbTinh.getSelectedItem().toString();
          String huyen = cmbHuyen.getSelectedItem().toString();
          String xa = cmbXa.getSelectedItem().toString();
          String diachi = xa + ", " + huyen + ", " + tinh;
          Boolean gioiTinhBool = null;
          if (gioitinhKH.equals("Nam")) {
            gioiTinhBool = true;
          } else if (gioitinhKH.equals("Nữ")) {
            gioiTinhBool = false;
          }
          LoaiThanhVien ltVien = new LoaiThanhVien();
          if (!soDinhDanh.isEmpty()) {
            String maloaitv = generator.tuTaoMaLoaiTV(soDinhDanh);
            int uudai = 1;
            String tenloaitv = "Thân Thiết";
            LocalDate ngaydangky = LocalDate.now();
            LocalDate ngayhethan = ngaydangky.plusYears(1);
            ltVien = new LoaiThanhVien(maloaitv, tenloaitv, uudai, ngaydangky, ngayhethan, soDinhDanh);
          } else {
            String maloaitv = generator.random3SoNguyen() + generator.random3SoNguyen() + "";
            ltVien.setMaLoaiTV(maloaitv);
          }
          KhachHang kh = new KhachHang(maKH, tenKH, sdtKH, gioiTinhBool, diachi, true);
          try {
            kh.setLoaiTV(ltVien);
          } catch (Exception e1) {
            e1.printStackTrace();
          }
          if (khachHangService.themKhachHang(kh) == true) {
            JOptionPane.showMessageDialog(null, "Thêm khách hàng thành công");
            loadTable();
            btnThemKH.setText("Thêm (F1)");
            btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
            btnSuaKH.setText("Sửa (F2)");
            btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
            unlockTextFields(false);
            xoaTrangKH();
            if (!sdt.isEmpty()) {
              this.dispose();
            }
          }

        } else {
          JOptionPane.showMessageDialog(null, "Vui lòng nhập đầy đủ thông tin");
        }
      } else if (btnThemKH.getText().equals("Huỷ (F1)")) {
        btnThemKH.setText("Thêm (F1)");
        btnSuaKH.setText("Sửa (F2)");
        btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
        unlockTextFields(false);
      }

    } else if (e.getSource() == btnXoaTrangKH) {
      xoaTrangKH();
      loadTable();

    } else if (e.getSource() == btnSuaKH) {
      if (btnSuaKH.getText().equals("Sửa (F2)")) {
        int row = tblKhachHang.getSelectedRow();
        if (row == -1) {
          JOptionPane.showMessageDialog(null, "Hãy chọn khách hàng cần sửa");
        } else {
          btnSuaKH.setText("Lưu (F2)");
          btnThemKH.setText("Huỷ (F1)");
          btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
          btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
          unlockTextFields(true);
          cmbHuyen.setEnabled(true);
          cmbXa.setEnabled(true);
        }
      } else if (btnSuaKH.getText().equals("Huỷ (F2)")) {
        btnThemKH.setText("Thêm (F1)");
        btnSuaKH.setText("Sửa (F2)");
        btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
        unlockTextFields(false);
      } else if (btnSuaKH.getText().equals("Lưu (F2)")) {
        if (checkEmpty()) {
          int row = tblKhachHang.getSelectedRow();
          String sdtKH = txtSdt.getText();
          String maKH = tblKhachHang.getValueAt(row, 0).toString();
          String tenKH = txtTenKH.getText();
          String soDinhDanh = txtSoDinhDanh.getText();
          int kiemtraKH = khachHangService.kiemtraKH(sdtKH, soDinhDanh);
          if (kiemtraKH == 1) {
            txtSdt.setFocusable(true);
            txtSdt.selectAll();
            JOptionPane.showMessageDialog(this, "Số điện thoại phải bằng 10 số");
            return;
          } else if (kiemtraKH == 2) {
            txtSoDinhDanh.setFocusable(true);
            JOptionPane.showMessageDialog(this, "Số định danh phải bằng 12 số");
          }
          String gioitinhKH = cmbGioiTinh.getSelectedItem().toString();
          String tinh = cmbTinh.getSelectedItem().toString();
          String huyen = cmbHuyen.getSelectedItem().toString();
          String xa = cmbXa.getSelectedItem().toString();
          String diachi = xa + ", " + huyen + ", " + tinh;
          Boolean gioiTinhBool = null;
          if (gioitinhKH.equals("Nam")) {
            gioiTinhBool = true;
          } else if (gioitinhKH.equals("Nữ")) {
            gioiTinhBool = false;
          }
          KhachHang kh = new KhachHang(maKH, tenKH, sdtKH, gioiTinhBool, diachi, true);
          if (khachHangService.suaKh(kh) == true) {
            JOptionPane.showMessageDialog(null, "Sửa khách hàng thành công");
            loadTable();
            btnThemKH.setText("Thêm (F1)");
            btnThemKH.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
            btnSuaKH.setText("Sửa (F2)");
            btnSuaKH.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
            unlockTextFields(false);
            xoaTrangKH();
          }
        }
      }
    } else if (e.getSource() == btnXoaKH) {
      xoaKH();
    } else if (e.getSource() == btnRefresh) {
      loadTable();
    } else if (e.getSource() == btnFilter) {
      String gioiTinhFilter = cmbGioiTinhFilter.getSelectedItem().toString();
      String loaitvfilter = cmbLoaiThanhVien.getSelectedItem().toString();

      loadTable();
      for (int i = 0; i < tblKhachHang.getRowCount(); i++) {
        flag = false;
        if (tblKhachHang.getValueAt(i, 3).toString().equals(gioiTinhFilter)
            && tblKhachHang.getValueAt(i, 5).toString().equals(loaitvfilter)) {
          flag = true;
        }
        if (flag == false) {
          tableModelKH.removeRow(i);
          i--;
        }
      }

    }

    else if (e.getSource() == btnTimkiemKH) {
      String maKH = txtTimkiemKH.getText();
      if (maKH.equals("")) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập tên để tìm kiếm KH");
      } else {
        String tenCanTim = txtTimkiemKH.getText();
        Boolean kq = false;
        String ten = "";
        // search tên nhân viên
        for (int i = 0; i < tblKhachHang.getRowCount(); i++) {
          Boolean result = false;
          String tenNV = tblKhachHang.getValueAt(i, 1).toString();
          String[] arrName = tenNV.split(" ");
          for (int a = 0; a < arrName.length; a++) {
            if (a < arrName.length - 1) {
              ten = arrName[a] + " " + arrName[a + 1];
              if (ten.equals(tenCanTim)) {
                result = true;
                kq = true;
              } else if (ten.toLowerCase().equals(tenCanTim)) {
                result = true;
                kq = true;
              } else if (generator.boDauTrongTu(ten).equals(tenCanTim)) {
                result = true;
                kq = true;
              } else if (generator.boDauTrongTu(ten).toLowerCase().equals(tenCanTim)) {
                result = true;
                kq = true;
              }
            } else if (arrName[a].equals(tenCanTim)) {
              result = true;
              kq = true;
            } else if (arrName[a].toLowerCase().equals(tenCanTim)) {
              result = true;
              kq = true;
            } else if (generator.boDauTrongTu(arrName[a]).equals(tenCanTim)) {
              result = true;
              kq = true;
            } else if (generator.boDauTrongTu(arrName[a]).toLowerCase().equals(tenCanTim)) {
              result = true;
              kq = true;
            }
          }
          if (tenNV.equals(tenCanTim)) {
            result = true;
            kq = true;
          }
          if (result == false) {
            tableModelKH.removeRow(i);
            i--;
          }
        }
        if (kq == false) {
          loadTable();
          JOptionPane.showMessageDialog(null, "Không tìm thấy khách hàng ");
        } else if (kq == true) {
          JOptionPane.showMessageDialog(null, "Tìm thấy khách hàng ");
          txtTimkiemKH.setText("");
        }
      }

    }

  }

  private void xoaKH() {
    int r = tblKhachHang.getSelectedRow();
    if (r == -1) {
      JOptionPane.showMessageDialog(null, "Không tìm thấy khách hàng để xoá");
      return;
    }
    int tb = JOptionPane.showConfirmDialog(this, "Bạn có chắc muốn xoá khách hàng này không", "Cảnh báo",
        JOptionPane.YES_NO_OPTION);
    if (tb == JOptionPane.YES_OPTION) {

      String maKH = tblKhachHang.getValueAt(r, 0).toString();
      if (khachHangService.xoaKH(maKH) == true) {
        tableModelKH.removeRow(r);
        JOptionPane.showMessageDialog(null, "Xóa khách hàng thành công");
      } else {
        JOptionPane.showMessageDialog(null, "Xóa khách hàng thất bại");
      }
    }
  }

  private void xoaTrangKH() {
    txtTenKH.setText("");
    txtSdt.setText("");
    txtSoDinhDanh.setText("");
  }

  private void loadTable() {
    // remove all rows
    tableModelKH.setRowCount(0);

    khachHangService.dsKH().forEach(kh -> {
      String gioiTinh = "";
      if (kh.getGioiTinh() == true)
        gioiTinh = "Nam";
      else
        gioiTinh = "Nữ";
      if (kh.isTrangThai()) {
        if (kh.getDiaChi() == null) {
          kh.setDiaChi("Chưa cập nhật");
        }
        if (kh.getLoaiTV().getSoDinhDanh() == null) {
          try {
            kh.getLoaiTV().setSoDinhDanh("Chưa cập nhật");
          } catch (Exception e) {
            e.printStackTrace();
          }
        }
        Object[] row = { kh.getMaKH().trim(), kh.getTenKH(), kh.getSdt().trim(), gioiTinh.trim(),
            kh.getDiaChi(), kh.getLoaiTV().getTenLoaiTV().trim(), kh.getLoaiTV().getSoDinhDanh() };
        tableModelKH.addRow(row);
      }
    });
  }

  // check empty
  private boolean checkEmpty() {
    if (txtTenKH.getText().equals("") || txtSdt.getText().equals("")) {
      return false;
    }
    return true;
  }

  @Override
  public void mouseClicked(MouseEvent e) {
    int row = tblKhachHang.getSelectedRow();
    txtTenKH.setText(tableModelKH.getValueAt(row, 1).toString());
    txtSoDinhDanh.setText(tableModelKH.getValueAt(row, 6).toString());
    txtSdt.setText(tableModelKH.getValueAt(row, 2).toString());
    cmbGioiTinh.setSelectedItem(tableModelKH.getValueAt(row, 3).toString());
    String[] diaChi = tableModelKH.getValueAt(row, 4).toString().split(", ");
    String tinh = "";
    String huyen = "";
    String xa = "";
    List<String> list = new ArrayList<>();
    for (int i = 0; i < diaChi.length; i++) {
      if (i >= diaChi.length - 3) {
        list.add(diaChi[i]);
      }
    }
    for (String s : list) {
      if (s.startsWith("t") || s.startsWith("T")) {
        tinh = s;
      } else if (s.startsWith("x") || s.startsWith("X") || s.startsWith("p") || s.startsWith("P") || s.startsWith("thị")
          || s.startsWith("Thị")) {
        xa = s;
      } else if (s.startsWith("h") || s.startsWith("H") || s.startsWith("q") || s.startsWith("Q") || s.startsWith("th")
          || s.startsWith("Th")) {
        huyen = s;
      }
    }

    if (!tinh.isEmpty()) {
      cmbTinh.setSelectedItem(tinh);
    }
    if (!huyen.isEmpty()) {
      cmbHuyen.setSelectedItem(huyen);
    }
    if (!xa.isEmpty()) {
      cmbXa.setSelectedItem(xa);
    }
    cmbTinh.setEnabled(false);
    cmbHuyen.setEnabled(false);
    cmbXa.setEnabled(false);
  }

  private void unlockTextFields(Boolean unlock) {
    txtTenKH.setEnabled(unlock);
    txtSdt.setEnabled(unlock);
    cmbTinh.setEnabled(unlock);

    cmbGioiTinh.setEnabled(unlock);
    txtSoDinhDanh.setEnabled(unlock);
  }

  @Override
  public void mousePressed(MouseEvent e) {
  }

  @Override
  public void mouseReleased(MouseEvent e) {

  }

  @Override
  public void mouseEntered(MouseEvent e) {

  }

  @Override
  public void mouseExited(MouseEvent e) {

  }
}
