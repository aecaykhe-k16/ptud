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
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
import javax.swing.SwingConstants;
import javax.swing.Timer;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.github.lgooddatepicker.components.DatePicker;
import com.github.lgooddatepicker.components.DatePickerSettings;

import bus.IDangNhapService;
import bus.INhanVienService;
import bus.IPhanCongCaLamService;
import bus.implement.DangNhapImp;
import bus.implement.NhanVienImp;
import bus.implement.PhanCongCaLamImp;
import entities.NhanVien;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.ReadJSONDiaChi;
import util.PlaceholderTextField;
import util.RoundedBorderWithColor;
import util.SpecialButton;

public class QLNhanVien extends JFrame implements ActionListener, MouseListener {
  private JLabel lblIconLogo, lblTitle;
  private JButton btnIconLogout;
  private JButton btnIconUser;
  private JPanel pnlMenu, pnlTop, pnInfo, pnlChucNang, pnlFilter, pnlCenter, pnlMainUI;
  private JLabel lblDSNV, lblDanhSachCaLam;
  private JButton btnThemNV, btnSuaNV, btnXoaNV, btnTimkiemNV;
  private PlaceholderTextField txtTimkiemNV;
  private DefaultComboBoxModel<String> dfBoxModelGioiTinh, dfBoxModelvitri, dfBoxModelViTriCongViec;
  private JComboBox<String> cmbGioiTinh, cmbViTriFilter, cmbViTriCongViec, cmbGioiTinhFilter;
  private JTable tblNhanVien;
  private DefaultTableModel tableModelNV;
  private JButton btnRefresh, btnFilter;

  private JButton btnNhanVien, btnPhong, btnKhachHang, btnHoaDon, btnThongke, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnDichVu;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblHoaDon, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu;
  private JLayeredPane layeredPane;
  private boolean flag = false;
  private JLabel lblTinh, lblHuyen, lblXa;
  private DefaultComboBoxModel<String> modelTinh, modelHuyen, modelXa;
  private JComboBox<String> cmbTinh, cmbHuyen, cmbXa;
  private ReadJSONDiaChi data = new ReadJSONDiaChi();
  private List<String> dsTinh = data.getDSTinh();

  private JLabel lblTenNV, lblSdt, lblNgayTuyenDung, lblNgaySinh, lblGioiTinh, lblViTriCongViec, lblEmail;
  private JTextField txtTenNV, txtSdt, txtEmail;
  DatePicker txtNgaySinh;
  private DatePicker txtNgayTuyenDung;
  private DatePickerSettings dateSettings;
  private Cursor handCursor = new Cursor(Cursor.HAND_CURSOR);
  private INhanVienService nhanVienService = new NhanVienImp();
  private IDangNhapService dangNhap = new DangNhapImp();
  private TaiKhoan tk;

  // function
  private Generator generator = new Generator();
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();

  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);

  public QLNhanVien(TaiKhoan taiKhoan) throws MalformedURLException {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;
    setTitle(Constants.APP_NAME);
    setExtendedState(MAXIMIZED_BOTH);
    setMinimumSize(new Dimension(1560, 830));
    this.setIconImage(imageIcon);
    setDefaultCloseOperation(EXIT_ON_CLOSE);
    setLocationRelativeTo(null);
    this.setBackground(Color.WHITE);
    setLayout(null);
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 2000, 1500);
    add(layeredPane);
    mainUI();
    handCursor = new Cursor(Cursor.HAND_CURSOR);

    dateSettings = new DatePickerSettings();
    dateSettings.setFormatForDatesCommonEra("dd/MM/yyyy");
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);
  }

  private void mainUI() {
    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 2000, 1400);
    PnlTop();
    PnlMenu();
    PnlCenter();
    pnlTable();
    layeredPane.add(pnlMainUI, Integer.valueOf(1));

    btnThemNV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnThemNV");
    btnThemNV.getActionMap().put("btnThemNV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnThemNV.doClick();
      }
    });
    btnSuaNV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F2, 0),
        "btnSuaNV");
    btnSuaNV.getActionMap().put("btnSuaNV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnSuaNV.doClick();
      }
    });
    btnXoaNV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F3, 0),
        "btnXoaNV");
    btnXoaNV.getActionMap().put("btnXoaNV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnXoaNV.doClick();
      }
    });
    btnFilter.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F4, 0),
        "btnFilter");
    btnFilter.getActionMap().put("btnFilter", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnFilter.doClick();
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
    btnTimkiemNV.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnTimkiemNV");
    btnTimkiemNV.getActionMap().put("btnTimkiemNV", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimkiemNV.doClick();
      }
    });

  }

  void pnlTable() {
    JPanel pnlBang = new JPanel();
    pnlBang.setLayout(new BorderLayout());

    String[] header = { "Mã nhân viên", "Họ Tên", "Số điện thoại", "Ngày Sinh", "Giới Tính ",
        "Ngày Tuyển Dụng", "Vị trí công việc", "Địa chỉ", "Email" };
    tableModelNV = new DefaultTableModel(header, 0);
    tblNhanVien = new JTable(tableModelNV);
    JScrollPane scrollPane = new JScrollPane(tblNhanVien);
    tblNhanVien.addMouseListener(this);
    tblNhanVien.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 15));
    tblNhanVien.setRowHeight(20);
    tblNhanVien.getTableHeader().setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 15));
    pnlBang.add(scrollPane);
    pnlBang.setBounds(10, 430, 1520, 360);
    tblNhanVien.setDefaultEditor(Object.class, null);
    loadTable();

    tblNhanVien.getColumnModel().getColumn(8).setMinWidth(170);
    tblNhanVien.getColumnModel().getColumn(4).setMaxWidth(80);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(SwingConstants.CENTER);
    for (int x = 0; x < 9; x++) {
      tblNhanVien.getColumnModel().getColumn(x).setCellRenderer(centerRenderer);
    }

    pnlMainUI.add(pnlBang);
  }

  void PnlCenter() {
    pnlCenter = new JPanel();
    pnlCenter.setBounds(20, 180, 1800, 250);
    pnlCenter.setLayout(null);
    lblDSNV = new JLabel("Danh sách nhân viên:");
    lblDSNV.setBounds(0, 200, 450, 70);
    lblDSNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    lblDSNV.setForeground(Color.decode(Constants.MENU_TITLE_COLOR));
    pnlCenter.add(lblDSNV);

    pnlChucNang = new JPanel();
    pnlChucNang.setLayout(null);
    pnlChucNang.setBounds(0, 0, 1800, 170);

    lblTenNV = new JLabel("Họ tên nhân viên:");
    lblTenNV.setBounds(50, 10, 200, 30);
    lblTenNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblTenNV);
    txtTenNV = new JTextField();
    txtTenNV.setBounds(200, 10, 490, 30);
    txtTenNV.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtTenNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtTenNV.setBackground(Color.WHITE);
    txtTenNV.setForeground(Color.BLACK);
    pnlChucNang.add(txtTenNV);

    lblSdt = new JLabel("Số điện thoại:");
    lblSdt.setBounds(50, 50, 200, 30);
    lblSdt.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblSdt);
    txtSdt = new JTextField();
    txtSdt.setBounds(200, 50, 490, 30);
    txtSdt.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtSdt.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(txtSdt);

    lblNgaySinh = new JLabel("Ngày sinh:");
    lblNgaySinh.setBounds(50, 90, 200, 30);
    lblNgaySinh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblNgaySinh);
    txtNgaySinh = new DatePicker(dateSettings);
    txtNgaySinh.setBounds(200, 90, 490, 30);
    pnlChucNang.add(txtNgaySinh);

    lblGioiTinh = new JLabel("Giới tính:");
    lblGioiTinh.setBounds(720, 10, 200, 30);
    lblGioiTinh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblGioiTinh);
    cmbGioiTinh = new JComboBox<>();
    cmbGioiTinh.addItem("Nam");
    cmbGioiTinh.addItem("Nữ");
    cmbGioiTinh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    cmbGioiTinh.setBounds(870, 10, 400, 30);
    cmbGioiTinh.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 10));
    cmbGioiTinh.setBackground(Color.decode("#ffffff"));
    pnlChucNang.add(cmbGioiTinh);

    lblNgayTuyenDung = new JLabel("Ngày tuyển dụng:");
    lblNgayTuyenDung.setBounds(720, 50, 200, 30);
    lblNgayTuyenDung.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblNgayTuyenDung);
    txtNgayTuyenDung = new DatePicker(dateSettings);
    txtNgayTuyenDung.setBounds(870, 50, 400, 30);
    pnlChucNang.add(txtNgayTuyenDung);

    lblViTriCongViec = new JLabel("Vị trí công việc:");
    lblViTriCongViec.setBounds(720, 90, 200, 30);
    lblViTriCongViec.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblViTriCongViec);
    String[] viTri = { "Quản lý", "Nhân viên" };
    dfBoxModelViTriCongViec = new DefaultComboBoxModel<>(viTri);
    dfBoxModelViTriCongViec.setSelectedItem("Quản lý");
    cmbViTriCongViec = new JComboBox<>(dfBoxModelViTriCongViec);
    cmbViTriCongViec.setBounds(870, 90, 400, 30);
    cmbViTriCongViec.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    cmbViTriCongViec.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 10));
    cmbViTriCongViec.setBackground(Color.decode("#ffffff"));
    pnlChucNang.add(cmbViTriCongViec);

    lblTinh = new JLabel("Tỉnh");
    lblTinh.setBounds(50, 130, 50, 30);
    lblTinh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));

    modelTinh = new DefaultComboBoxModel<>();
    modelTinh.addElement("Chọn tỉnh");
    for (String string : dsTinh) {
      modelTinh.addElement(string);
    }
    cmbTinh = new JComboBox<>(modelTinh);
    cmbTinh.setBounds(100, 130, 150, 30);
    pnlChucNang.add(lblTinh);
    pnlChucNang.add(cmbTinh);

    lblHuyen = new JLabel("Huyện");
    lblHuyen.setBounds(260, 130, 50, 30);
    lblHuyen.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    modelHuyen = new DefaultComboBoxModel<>();
    modelHuyen.addElement("Chọn huyện");
    cmbHuyen = new JComboBox<>(modelHuyen);
    cmbHuyen.setBounds(320, 130, 150, 30);
    cmbHuyen.setEnabled(false);
    pnlChucNang.add(lblHuyen);
    pnlChucNang.add(cmbHuyen);

    lblXa = new JLabel("Xã");
    lblXa.setBounds(500, 130, 50, 30);
    lblXa.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    modelXa = new DefaultComboBoxModel<>();
    modelXa.addElement("Chọn xã");
    cmbXa = new JComboBox<>(modelXa);
    cmbXa.setBounds(540, 130, 150, 30);
    cmbXa.setEnabled(false);
    pnlChucNang.add(lblXa);
    pnlChucNang.add(cmbXa);

    lblEmail = new JLabel("Email:");
    lblEmail.setBounds(720, 130, 200, 30);
    lblEmail.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(lblEmail);
    txtEmail = new JTextField();
    txtEmail.setBounds(870, 130, 400, 30);
    txtEmail.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 15));
    txtEmail.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    pnlChucNang.add(txtEmail);

    btnThemNV = new MyButton(20, Color.decode(Constants.BTN_CONFIRM_COLOR), Color.decode(Constants.THIRD_COLOR));
    btnThemNV.setText("Thêm(F1)");
    btnThemNV.setBounds(1300, 15, 150, 35);
    btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
    btnThemNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnThemNV.setCursor(handCursor);
    btnThemNV.setBorderPainted(false);
    btnThemNV.setFocusPainted(false);
    pnlChucNang.add(btnThemNV);

    btnSuaNV = new MyButton(20, Color.decode(Constants.BTN_EDIT_COLOR), Color.decode(Constants.THIRD_COLOR));
    btnSuaNV.setText("Sửa(F2)");
    btnSuaNV.setBounds(1300, 65, 150, 35);
    btnSuaNV.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
    btnSuaNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnSuaNV.setCursor(handCursor);
    btnSuaNV.setBorderPainted(false);
    btnSuaNV.setFocusPainted(false);
    pnlChucNang.add(btnSuaNV);

    btnXoaNV = new MyButton(20, Color.WHITE, Color.WHITE);
    btnXoaNV.setText("Xóa(F3)");
    btnXoaNV.setBounds(1300, 115, 150, 35);
    btnXoaNV.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    btnXoaNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnXoaNV.setCursor(handCursor);
    btnXoaNV.setBorderPainted(false);
    btnXoaNV.setFocusPainted(false);
    pnlChucNang.add(btnXoaNV);
    // Disable text field
    unlockTextFields(false);

    pnlCenter.add(pnlChucNang);

    pnlFilter = new JPanel();
    pnlFilter.setLayout(null);
    pnlFilter.setBounds(0, 180, 1800, 70);

    JLabel lblGioiTinhFilter = new JLabel("Giới tính:");
    lblGioiTinhFilter.setBounds(100, 3, 200, 20);
    lblGioiTinhFilter.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlFilter.add(lblGioiTinhFilter);

    dfBoxModelGioiTinh = new DefaultComboBoxModel<String>();
    dfBoxModelGioiTinh.addElement("");
    dfBoxModelGioiTinh.addElement("Nam");
    dfBoxModelGioiTinh.addElement("Nữ");
    cmbGioiTinhFilter = new JComboBox<String>(dfBoxModelGioiTinh);
    cmbGioiTinhFilter.setBounds(170, 3, 100, 25);
    cmbGioiTinhFilter.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    cmbGioiTinhFilter.setBackground(Color.WHITE);
    pnlFilter.add(cmbGioiTinhFilter);

    JLabel lblViTriCongViecFilter = new JLabel("Vị trí công việc:");
    lblViTriCongViecFilter.setBounds(300, 3, 200, 20);
    lblViTriCongViecFilter.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    pnlFilter.add(lblViTriCongViecFilter);

    dfBoxModelvitri = new DefaultComboBoxModel<String>();
    dfBoxModelvitri.addElement("");
    dfBoxModelvitri.addElement("Nhân viên");
    dfBoxModelvitri.addElement("Quản lý");
    cmbViTriFilter = new JComboBox<String>(dfBoxModelvitri);
    cmbViTriFilter.setBounds(420, 3, 150, 25);
    cmbViTriFilter.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    cmbViTriFilter.setBackground(Color.decode("#ffffff"));
    pnlFilter.add(cmbViTriFilter);

    btnFilter = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnFilter.setText("Lọc(F4)");
    btnFilter.setBounds(600, 0, 120, 30);
    btnFilter.setIcon(FontIcon.of(FontAwesomeSolid.FILTER, 20, Color.BLACK));
    btnFilter.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    btnFilter.setCursor(handCursor);
    btnFilter.setBorderPainted(false);
    btnFilter.setFocusPainted(false);
    pnlFilter.add(btnFilter);

    btnTimkiemNV = new MyButton(15, Color.decode(Constants.BTN_FILTER_COLOR), Color.decode(Constants.BTN_FILTER_COLOR));
    btnTimkiemNV.setBounds(1160, 0, 150, 30);
    btnTimkiemNV.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20, Color.BLACK));
    btnTimkiemNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnTimkiemNV.setCursor(handCursor);
    btnTimkiemNV.setBorderPainted(false);
    btnTimkiemNV.setFocusPainted(false);
    pnlFilter.add(btnTimkiemNV);
    txtTimkiemNV = new PlaceholderTextField(Color.GRAY, false);
    txtTimkiemNV.setPlaceholder("Nhập tên nhân viên");
    txtTimkiemNV.setBounds(900, 0, 250, 30);
    txtTimkiemNV.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 17));
    txtTimkiemNV.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    pnlFilter.add(txtTimkiemNV);

    btnRefresh = new JButton("");
    btnRefresh.setBounds(1350, 0, 30, 30);
    btnRefresh.setBackground(new Color(238, 238, 238));
    btnRefresh.setBorder(null);
    btnRefresh.setIcon(FontIcon.of(FontAwesomeSolid.REDO, 20, Color.BLACK));
    btnRefresh.setToolTipText("Refresh");
    btnRefresh.setCursor(handCursor);
    btnRefresh.setBorderPainted(false);
    btnRefresh.setFocusPainted(false);
    pnlFilter.add(btnRefresh);

    pnlCenter.add(pnlFilter);
    pnlMainUI.add(pnlCenter);

    btnThemNV.addActionListener(this);
    btnXoaNV.addActionListener(this);
    btnSuaNV.addActionListener(this);
    btnTimkiemNV.addActionListener(this);
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
      btnNhanVien.setIcon(FontIcon.of(FontAwesomeSolid.USERS, 30, Color.decode("#7743DB")));
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

    pnlMainUI.add(pnlMenu);

  }

  void PnlTop() {
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

    lblDanhSachCaLam = new JLabel(caLamService.getCaTucTheoNV(tk.getEmail()));
    lblDanhSachCaLam.setBounds(1090, 70, 250, 20);
    lblDanhSachCaLam.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 16));
    lblDanhSachCaLam.setForeground(Color.decode("#FFFFFFF"));
    Timer t = new Timer(500, this); // set a timer
    // set animation for timer
    t.setInitialDelay(0);
    t.start();
    pnlTop.add(lblDanhSachCaLam);

    btnIconUser.setCursor(handCursor);
    btnIconLogout.setCursor(handCursor);

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
      } else if (e.getSource() == btnKhachHang) {
        new QuanLyKhachHang(tk, "").setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnThongke) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnPhanCong) {
        new PhanCongCaLam(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnQuanLyDatPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconUser) {
        new ThongTinNguoiDung(tk).setVisible(true);
      } else if (e.getSource() == btnHoaDon) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
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
    if (e.getSource() == btnThemNV) {
      if (btnThemNV.getText().equals("Thêm(F1)")) {
        txtTenNV.requestFocus();
        btnSuaNV.setText("Hủy(F2)");
        btnThemNV.setText("Lưu(F1)");
        btnXoaNV.setText("Xóa trắng(F3)");
        btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
        btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
        btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.ERASER, 20, Color.RED));
        unlockTextFields(true);
        clearTextField();
      } else if (btnThemNV.getText().equals("Lưu(F1)")) {
        if (checkEmpty() == true) {

          String tenNV = txtTenNV.getText();
          LocalDate ngaySinh = txtNgaySinh.getDate();
          String sdt = txtSdt.getText();
          LocalDate ngayTuyenDung = txtNgayTuyenDung.getDate();
          String gioiTinh = cmbGioiTinh.getSelectedItem().toString();
          String viTriCongViec = cmbViTriCongViec.getSelectedItem().toString();
          String ngaySinhFormat = ngaySinh.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          String ngayTuyenDungFormat = ngayTuyenDung.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          String loaiNv = viTriCongViec.equals("Quản lý") ? "QL" : "NV";
          int namSinh = ngaySinh.getYear();
          String maNV = generator.tuTaoMaNV(loaiNv, namSinh);
          // kiểm tra trùng mã
          for (int i = 0; i < tableModelNV.getRowCount(); i++) {
            while (maNV.equals(tableModelNV.getValueAt(i, 0).toString())) {
              maNV = generator.tuTaoMaNV(loaiNv, namSinh);
            }
          }
          ngaySinh = LocalDate.parse(ngaySinhFormat, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          ngayTuyenDung = LocalDate.parse(ngayTuyenDungFormat, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          Boolean gioiTinhBool = null;
          if (gioiTinh.equals("Nam")) {
            gioiTinhBool = true;
          } else if (gioiTinh.equals("Nữ")) {
            gioiTinhBool = false;
          }
          String tinh = cmbTinh.getSelectedItem().toString();
          String huyen = cmbHuyen.getSelectedItem().toString();
          String xa = cmbXa.getSelectedItem().toString();
          String diaChi = xa + ", " + huyen + ", " + tinh;
          String email = generator.taoEmail(tenNV, maNV);
          TaiKhoan taiKhoan = new TaiKhoan(email);
          NhanVien nv = new NhanVien(maNV, tenNV, sdt, ngaySinh, gioiTinhBool, ngayTuyenDung, viTriCongViec, diaChi,
              true);
          nv.setTaiKhoan(taiKhoan);
          if (nhanVienService.kiemTraThongTin(nv) == 0) {
            if (nhanVienService.themNV(nv)) {
              JOptionPane.showMessageDialog(null, "Thêm nhân viên thành công");
              loadTable();
              btnThemNV.setText("Thêm(F1)");
              btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
              btnSuaNV.setText("Sửa(F2)");
              btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
              btnXoaNV.setText("Xóa(F3)");
              btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
              unlockTextFields(false);
              clearTextField();
            } else {
              JOptionPane.showMessageDialog(null, "Thêm nhân viên thất bại");
            }
          } else if (nhanVienService.kiemTraThongTin(nv) == 1) {
            JOptionPane.showMessageDialog(null,
                "Số điện thoại không hợp lệ(gồm 10 số không chưa ký tự chữ) và phải bắt đầu bằng số 0");
          } else if (nhanVienService.kiemTraThongTin(nv) == 3) {
            JOptionPane.showMessageDialog(null, "Ngày tuyển dụng không được nhỏ hơn ngày hiện tại");
          } else if (nhanVienService.kiemTraThongTin(nv) == 4) {
            JOptionPane.showMessageDialog(null, "Ngày sinh không được lớn hơn ngày hiện tại");
          } else if (nhanVienService.kiemTraThongTin(nv) == 5) {
            JOptionPane.showMessageDialog(null, "Nhân viên phải đủ 18 tuổi trở lên");
          }
        } else {
          JOptionPane.showMessageDialog(null, "Vui lòng nhập đầy đủ thông tin");
        }

      } else if (btnThemNV.getText().equals("Hủy(F1)")) {
        btnThemNV.setText("Thêm(F1)");
        btnSuaNV.setText("Sửa(F2)");
        btnXoaNV.setText("Xóa(F3)");
        btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
        btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        unlockTextFields(false);
        btnThemNV.setBackground(Color.decode("#7ed957"));
        btnSuaNV.setBackground(Color.decode("#ffdf2b"));
      }

    } else if (e.getSource() == btnXoaNV) {
      if (btnXoaNV.getText().equals("Xóa(F3)")) {
        int row = tblNhanVien.getSelectedRow();
        if (row == -1) {
          JOptionPane.showMessageDialog(null, "Bạn chưa chọn nhân viên để xóa");
        } else {
          int dialogButton = JOptionPane.showConfirmDialog(null, "Bạn có chắc chắn muốn xóa nhân viên này không?",
              "Xác nhận",
              JOptionPane.YES_NO_OPTION);
          if (dialogButton == JOptionPane.YES_OPTION) {
            String maNV = tblNhanVien.getValueAt(row, 0).toString();
            String email = tblNhanVien.getValueAt(row, 8).toString();
            if (nhanVienService.xoaNV(maNV, email)) {

              tableModelNV.removeRow(row);
              JOptionPane.showMessageDialog(null, "Xóa nhân viên thành công");
            } else {

              JOptionPane.showMessageDialog(null, "Xóa nhân viên thất bại");
            }
          } else if (dialogButton == JOptionPane.NO_OPTION) {

          }
        }
        clearTextField();
      }
      if (btnXoaNV.getText().equals("Xóa trắng(F3)")) {
        clearTextField();
      }
    } else if (e.getSource() == btnSuaNV) {
      if (btnSuaNV.getText().equals("Sửa(F2)")) {
        int row = tblNhanVien.getSelectedRow();
        if (row == -1) {
          JOptionPane.showMessageDialog(null, "Hãy chọn nhân viên cần sửa");
        } else {
          txtTenNV.requestFocus();
          btnSuaNV.setText("Lưu(F2)");
          btnThemNV.setText("Hủy(F1)");
          btnXoaNV.setText("Xóa trắng(F3)");
          btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.TIMES, 20));
          btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
          btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.ERASER, 20, Color.RED));
          unlockTextFields(true);
          txtNgayTuyenDung.setEnabled(false);
          btnThemNV.setBackground(Color.decode("#ffdf2b"));
          btnSuaNV.setBackground(Color.decode("#7ed957"));
        }
      } else if (btnSuaNV.getText().equals("Hủy(F2)")) {
        btnThemNV.setText("Thêm(F1)");
        btnSuaNV.setText("Sửa(F2)");
        btnXoaNV.setText("Xóa(F3)");
        btnThemNV.setBackground(Color.decode("#7ed957"));
        btnSuaNV.setBackground(Color.decode("#ffdf2b"));
        btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
        btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
        btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
        unlockTextFields(false);
      } else if (btnSuaNV.getText().equals("Lưu(F2)")) {
        if (checkEmpty()) {
          int row = tblNhanVien.getSelectedRow();
          String maNV = tblNhanVien.getValueAt(row, 0).toString();
          String tenNV = txtTenNV.getText();
          LocalDate ngaySinh = txtNgaySinh.getDate();
          String sdt = txtSdt.getText();
          LocalDate ngayTuyenDung = txtNgayTuyenDung.getDate();
          String gioiTinh = cmbGioiTinh.getSelectedItem().toString();
          String viTriCongViec = cmbViTriCongViec.getSelectedItem().toString();
          String ngaySinhFormat = ngaySinh.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          String ngayTuyenDungFormat = ngayTuyenDung.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));

          ngaySinh = LocalDate.parse(ngaySinhFormat, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          ngayTuyenDung = LocalDate.parse(ngayTuyenDungFormat, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
          Boolean gioiTinhBool = null;
          if (gioiTinh.equals("Nam")) {
            gioiTinhBool = true;
          } else if (gioiTinh.equals("Nữ")) {
            gioiTinhBool = false;
          }
          String tinh = cmbTinh.getSelectedItem().toString();
          String huyen = cmbHuyen.getSelectedItem().toString();
          String xa = cmbXa.getSelectedItem().toString();
          String diaChi = xa + ", " + huyen + ", " + tinh;
          String email = txtEmail.getText();
          TaiKhoan taiKhoan = new TaiKhoan(email);
          NhanVien nv = new NhanVien(maNV, tenNV, sdt, ngaySinh, gioiTinhBool, ngayTuyenDung, viTriCongViec, diaChi);
          nv.setTaiKhoan(taiKhoan);
          if (nhanVienService.kiemTraThongTin(nv) == 0) {
            if (nhanVienService.suaNV(nv)) {
              btnThemNV.setText("Thêm(F1)");
              btnSuaNV.setText("Sửa(F2)");
              btnXoaNV.setText("Xóa(F3)");
              btnThemNV.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
              btnSuaNV.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
              btnXoaNV.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
              btnThemNV.setBackground(Color.decode("#7ed957"));
              btnSuaNV.setBackground(Color.decode("#ffdf2b"));
              unlockTextFields(false);
              clearTextField();
              loadTable();
              JOptionPane.showMessageDialog(null, "Sửa nhân viên thành công");
            } else {
              JOptionPane.showMessageDialog(null, "Sửa nhân viên thất bại");
            }
          } else if (nhanVienService.kiemTraThongTin(nv) == 1) {
            JOptionPane.showMessageDialog(null,
                "Số điện thoại không hợp lệ(gồm 10 số không chưa ký tự chữ) và phải bắt đầu bằng số 0");
          } else if (nhanVienService.kiemTraThongTin(nv) == 4) {
            JOptionPane.showMessageDialog(null,
                "Ngày sinh không được lớn hơn ngày hiện tại");
          } else if (nhanVienService.kiemTraThongTin(nv) == 5) {
            JOptionPane.showMessageDialog(null, "Nhân viên phải đủ 18 tuổi trở lên");
          }
        } else {
          JOptionPane.showMessageDialog(null, "Vui lòng nhập đầy đủ thông tin");
        }
      }
    } else if (e.getSource() == btnTimkiemNV) {
      loadTable();
      if (txtTimkiemNV.getText().equals("")) {
        JOptionPane.showMessageDialog(null, "Vui lòng nhập thông tin tìm kiếm");
      } else {
        String tenCanTim = txtTimkiemNV.getText();
        Boolean kq = false;
        String ten = "";
        // search tên nhân viên
        for (int i = 0; i < tblNhanVien.getRowCount(); i++) {
          Boolean result = false;
          String tenNV = tblNhanVien.getValueAt(i, 1).toString();
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
            tableModelNV.removeRow(i);
            i--;
          }
        }
        if (kq == false) {
          loadTable();
          JOptionPane.showMessageDialog(null, "Không tìm thấy nhân viên ");
        } else if (kq == true) {
          JOptionPane.showMessageDialog(null, "Tìm thấy nhân viên ");
          txtTimkiemNV.setText("");
        }
      }
    } else if (e.getSource() == btnRefresh) {
      loadTable();
      clearTextField();
    } else if (e.getSource() == btnFilter) {
      String gioiTinhFilter = cmbGioiTinhFilter.getSelectedItem().toString();
      String viTriFilter = cmbViTriFilter.getSelectedItem().toString();
      loadTable();
      if (gioiTinhFilter != "" && viTriFilter != "") {
        for (int i = 0; i < tblNhanVien.getRowCount(); i++) {
          flag = false;
          if (tblNhanVien.getValueAt(i, 4).toString().equals(gioiTinhFilter)
              && tblNhanVien.getValueAt(i, 6).toString().equals(viTriFilter)) {
            flag = true;
          }
          if (flag == false) {
            tableModelNV.removeRow(i);
            i--;
          }
        }
      } else if (gioiTinhFilter != "") {
        for (int i = 0; i < tblNhanVien.getRowCount(); i++) {
          if (tblNhanVien.getValueAt(i, 4).equals(gioiTinhFilter)) {
          } else {
            tableModelNV.removeRow(i);
            i--;
          }
        }
      } else if (viTriFilter != "") {
        for (int i = 0; i < tblNhanVien.getRowCount(); i++) {
          if (tblNhanVien.getValueAt(i, 6).equals(viTriFilter)) {
          } else {
            tableModelNV.removeRow(i);
            i--;
          }
        }
      }

    }
  }

  private void unlockTextFields(Boolean unlock) {
    txtTenNV.setEnabled(unlock);
    txtSdt.setEnabled(unlock);
    txtNgaySinh.setEnabled(unlock);
    cmbGioiTinh.setEnabled(unlock);
    txtNgayTuyenDung.setEnabled(unlock);
    cmbViTriCongViec.setEnabled(unlock);
    cmbTinh.setEnabled(unlock);
    txtEmail.setEnabled(false);
  }

  private void clearTextField() {
    txtTenNV.setText("");
    txtSdt.setText("");
    txtNgaySinh.setDate(null);
    txtNgayTuyenDung.setDate(null);
    cmbGioiTinh.setSelectedIndex(0);
    cmbViTriCongViec.setSelectedIndex(0);
    txtEmail.setText("");
  }

  private void loadTable() {
    tableModelNV.setRowCount(0);

    nhanVienService.dsNV().forEach(nv -> {
      String gioiTinh = "";
      if (nv.getGioiTinh() == true)
        gioiTinh = "Nam";
      else
        gioiTinh = "Nữ";
      String formatNgaySinh = nv.getNgaySinh().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
      String formatNgayTuyenDung = nv.getNgayTuyenDung().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
      Object[] row = { nv.getMaNV(), nv.getTenNV(), nv.getSdt(), formatNgaySinh, gioiTinh,
          formatNgayTuyenDung, nv.getViTriCongViec(), nv.getDiaChi(), nv.getTaiKhoan().getEmail().trim() };
      tableModelNV.addRow(row);
    });
  }

  // check empty
  private boolean checkEmpty() {
    if (txtTenNV.getText().equals("") || txtSdt.getText().equals("") || txtNgaySinh.getDate() == null
        || txtNgayTuyenDung.getDate() == null) {
      return false;
    }
    return true;
  }

  @Override
  public void mouseClicked(MouseEvent e) {

    int row = tblNhanVien.getSelectedRow();
    txtTenNV.setText(tblNhanVien.getValueAt(row, 1).toString());
    txtSdt.setText(tblNhanVien.getValueAt(row, 2).toString());
    String ngaySinh = tblNhanVien.getValueAt(row, 3).toString();
    txtNgaySinh.setText(generator.parseLocaldateToDatetimepicker(ngaySinh));
    txtNgaySinh.setText(tblNhanVien.getValueAt(row, 3).toString());
    cmbGioiTinh.setSelectedItem(tblNhanVien.getValueAt(row, 4).toString());

    txtNgayTuyenDung.setText(generator.parseLocaldateToDatetimepicker(tblNhanVien.getValueAt(row, 5).toString()));
    cmbViTriCongViec.setSelectedItem(tblNhanVien.getValueAt(row, 6).toString());
    String[] diaChi = tblNhanVien.getValueAt(row, 7).toString().split(", ");
    String tinh = "";
    String huyen = "";
    String xa = "";

    for (String s : diaChi) {
      if (s.startsWith("x") || s.startsWith("X") || s.startsWith("p") || s.startsWith("P")
          || s.startsWith("thị")
          || s.startsWith("Thị")) {
        xa = s;
      } else if (s.startsWith("h") || s.startsWith("H") || s.startsWith("q") || s.startsWith("Q")
          || s.startsWith("th")
          || s.startsWith("Th")) {
        huyen = s;
      } else {
        tinh = s;
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
    txtEmail.setText(tblNhanVien.getValueAt(row, 8).toString());

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