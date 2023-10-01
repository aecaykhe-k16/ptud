package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.HeadlessException;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.Timer;
import javax.swing.border.LineBorder;
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableCellRenderer;
import javax.swing.table.DefaultTableModel;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.github.lgooddatepicker.components.DatePicker;
import com.github.lgooddatepicker.components.DatePickerSettings;

import bus.IDangNhapService;
import bus.implement.DangNhapImp;
import bus.implement.NhanVienImp;
import bus.implement.PhanCongCaLamImp;
import entities.CaTruc;
import entities.ChiTietCaTruc;
import entities.NhanVien;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.RoundedBorderWithColor;
import util.SpecialButton;

public class PhanCongCaLam extends JFrame implements ActionListener, MouseListener {
  private JLabel lblIconLogo, lblTitle, lblDanhSachCaLam;
  private JPanel pnlMenu, pnlTop, pnlCenter, pnlMainUI;
  private JLabel lblTenNhanVien, lblThoiGian, lblNgay, lblDate, lblHoaDon;
  private JButton btnXuatFile, btnThem, btnLuu, btnXoa, btnTim, btnRefresh;
  private DatePicker txtNgay, txtDate;
  JComboBox<String> cmbCaLam, comboBoxNhanVien, cmbLocOption, cmbLocTenNhanVien, cmbLocTheoCa;
  private JTable tablePhanCongCaLam;
  private DefaultTableModel tableModelPhanCongCaLam;
  private Cursor handCursor;
  private DatePickerSettings dateSettings;
  // slidebar
  private JPanel pnInfo;
  private JButton btnNhanVien, btnPhong, btnKhachHang, btnThongke, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnIconUser, btnIconLogout, btnDichVu, btnHoaDon;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu;
  private JLayeredPane layeredPane;
  /**
   * DATA
   */
  private NhanVienImp nhanVienImp = new NhanVienImp();
  private PhanCongCaLamImp caLamService = new PhanCongCaLamImp();
  private List<ChiTietCaTruc> dsCaTruc = new ArrayList<ChiTietCaTruc>();

  private IDangNhapService dangNhap = new DangNhapImp();
  private TaiKhoan tk;
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private Generator generator = new Generator();

  public PhanCongCaLam(TaiKhoan taiKhoan) throws MalformedURLException {

    try {
      ConnectDB.getInstance().connect();
    } catch (Exception e) {
      e.printStackTrace();
    }
    tk = taiKhoan;
    setTitle("Karaoke NNice");
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
    handCursor = new Cursor(Cursor.HAND_CURSOR);

    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 2000, 1400);
    handCursor = new Cursor(Cursor.HAND_CURSOR);
    layeredPane.add(pnlMainUI, 1);
    PnlTop();
    PnlMenu();
    PnlCenter();

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
      btnPhanCong.setIcon(FontIcon.of(FontAwesomeSolid.TASKS, 30, Color.decode("#7743DB")));
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

  void PnlCenter() {
    Font fontchu = new Font(Constants.MAIN_FONT, Font.BOLD, 20);
    Font fontchu1 = new Font(Constants.MAIN_FONT, Font.PLAIN, 18);

    pnlCenter = new JPanel();
    pnlCenter.setBounds(0, 160, 1800, 600);
    pnlCenter.setLayout(null);

    lblTenNhanVien = new JLabel("Nhân viên:");
    lblTenNhanVien.setBounds(80, 30, 150, 30);
    lblTenNhanVien.setFont(fontchu);

    comboBoxNhanVien = new JComboBox<>();
    UpdataComboboxNhanVien();
    comboBoxNhanVien.setFont(fontchu1);
    comboBoxNhanVien.setBounds(230, 30, 250, 30);

    lblThoiGian = new JLabel("Thời gian:");
    lblThoiGian.setBounds(600, 30, 150, 30);
    lblThoiGian.setFont(fontchu);

    cmbCaLam = new JComboBox<String>();
    cmbCaLam.setFont(fontchu1);
    cmbCaLam.setBounds(750, 30, 250, 35);

    dsCaTruc = caLamService.getDanhSachCTCaTruc();
    UpdataCaLam(dsCaTruc);

    lblNgay = new JLabel("Ngày:");
    lblNgay.setBounds(1100, 30, 100, 30);
    lblNgay.setFont(fontchu);

    dateSettings = new DatePickerSettings();
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);
    txtNgay = new DatePicker(dateSettings);
    txtNgay.setFont(fontchu1);
    txtNgay.setBorder(new RoundedBorderWithColor(new Color(255, 233, 210), 1, 30));
    txtNgay.setBounds(1210, 30, 250, 35);
    LocalDate localDate = LocalDate.now();// For reference
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd LLLL yyyy");
    String formattedString = localDate.format(formatter);
    txtNgay.setText(formattedString);

    JPanel pnLocDanhSach = new JPanel();
    pnLocDanhSach.setLayout(null);
    pnLocDanhSach.setBounds(80, 100, 700, 70);
    pnLocDanhSach.setBorder(new TitledBorder(new LineBorder(Color.black), "Lọc danh sách ca trực"));

    lblDate = new JLabel("Lọc theo:");
    lblDate.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 15));
    lblDate.setBounds(10, 20, 150, 30);

    cmbLocOption = new JComboBox<String>();
    cmbLocOption.setBounds(90, 20, 150, 30);
    cmbLocOption.addItem("Theo ngày");
    cmbLocOption.addItem("Theo ca");
    cmbLocOption.addItem("Theo tên nhân viên");

    dateSettings = new DatePickerSettings();
    dateSettings.setAllowKeyboardEditing(false);
    dateSettings.setFirstDayOfWeek(DayOfWeek.MONDAY);
    txtDate = new DatePicker(dateSettings);
    txtDate.setBounds(260, 20, 160, 30);
    txtDate.setDate(LocalDate.now());

    cmbLocTenNhanVien = new JComboBox<>();
    for (int i = 0; i < comboBoxNhanVien.getItemCount(); i++) {
      cmbLocTenNhanVien.addItem(comboBoxNhanVien.getItemAt(i).toString());
    }
    cmbLocTenNhanVien.setBounds(260, 20, 160, 30);

    cmbLocTheoCa = new JComboBox<String>();
    for (int i = 0; i < cmbCaLam.getItemCount(); i++) {
      cmbLocTheoCa.addItem(cmbCaLam.getItemAt(i).toString().trim());
    }
    cmbLocTheoCa.setBounds(260, 20, 160, 30);

    cmbLocOption.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        int index = cmbLocOption.getSelectedIndex();
        if (index == 0) {
          txtDate.setBounds(260, 20, 160, 30);
          cmbLocTenNhanVien.setBounds(260, 20, 0, 0);
          cmbLocTheoCa.setBounds(260, 20, 0, 0);
        } else if (index == 1) {
          txtDate.setBounds(260, 20, 0, 0);
          cmbLocTenNhanVien.setBounds(260, 20, 0, 0);
          cmbLocTheoCa.setBounds(260, 20, 160, 30);
        } else if (index == 2) {
          txtDate.setBounds(260, 20, 0, 0);
          cmbLocTenNhanVien.setBounds(260, 20, 170, 30);
          cmbLocTheoCa.setBounds(260, 20, 0, 0);
        }
      }
    });

    btnTim = new MyButton(15, Color.cyan, Color.decode("#F0F0F0"));
    btnTim.setBounds(450, 20, 100, 30);
    btnTim.setText("Lọc");
    btnTim.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnTim.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));

    btnRefresh = new JButton("");
    btnRefresh.setBounds(580, 20, 100, 30);
    btnRefresh.setBackground(new Color(238, 238, 238));
    btnRefresh.setIcon(FontIcon.of(FontAwesomeSolid.REDO, 20));

    btnLuu = new MyButton(15, Color.ORANGE, Color.decode("#F0F0F0"));
    btnLuu.setText("Sủa");
    btnLuu.setIcon(FontIcon.of(FontAwesomeSolid.SAVE, 20));
    btnLuu.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnLuu.setBounds(1160, 120, 130, 35);

    btnThem = new MyButton(15, Color.decode("#00FFD1"), Color.decode("#F0F0F0"));
    btnThem.setBounds(830, 120, 130, 35);
    btnThem.setText("Thêm");
    btnThem.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnThem.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));

    btnXoa = new MyButton(15, Color.white, Color.decode("#F0F0F0"));
    btnXoa.setText("Xóa");
    btnXoa.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnXoa.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    btnXoa.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnXoa.setBounds(997, 120, 130, 35);

    CreateTable();
    UpdataTable();

    btnXuatFile = new MyButton(15, Color.decode("#22B8E7"), Color.decode("#F0F0F0"));
    btnXuatFile.setText("Xuất file");
    btnXuatFile.setBounds(1330, 120, 130, 35);
    btnXuatFile.setBorder(new RoundedBorderWithColor(new Color(238, 238, 238), 1, 20));
    btnXuatFile.setIcon(FontIcon.of(FontAwesomeSolid.FILE_EXCEL, 20));

    pnlCenter.add(btnThem);
    pnlCenter.add(btnLuu);
    pnlCenter.add(btnXoa);
    pnlCenter.add(pnLocDanhSach);
    pnLocDanhSach.add(cmbLocOption);
    pnLocDanhSach.add(txtDate);
    pnLocDanhSach.add(cmbLocTenNhanVien);
    pnLocDanhSach.add(cmbLocTheoCa);
    pnLocDanhSach.add(btnTim);
    pnLocDanhSach.add(lblDate);
    pnLocDanhSach.add(btnRefresh);
    pnlCenter.add(comboBoxNhanVien);

    pnlCenter.add(lblThoiGian);
    pnlCenter.add(cmbCaLam);
    pnlCenter.add(lblNgay);
    pnlCenter.add(txtNgay);
    pnlCenter.add(lblTenNhanVien);
    pnlCenter.add(btnXuatFile);
    pnlMainUI.add(pnlCenter);

    btnLuu.addActionListener(this);
    btnLuu.setCursor(handCursor);

    btnXoa.addActionListener(this);
    btnXoa.setCursor(handCursor);

    btnTim.addActionListener(this);
    btnTim.setCursor(handCursor);

    btnThem.addActionListener(this);
    btnThem.setCursor(handCursor);

    btnRefresh.addActionListener(this);
    btnRefresh.setCursor(handCursor);

    btnXuatFile.addActionListener(this);
    btnXuatFile.setCursor(handCursor);

    cmbCaLam.setCursor(handCursor);
    cmbLocOption.setCursor(handCursor);
    cmbLocTenNhanVien.setCursor(handCursor);
    comboBoxNhanVien.setCursor(handCursor);
    txtDate.setCursor(handCursor);
    txtNgay.setCursor(handCursor);
    cmbLocTheoCa.setCursor(handCursor);

  }

  /**
   * loadata combobox ca làm
   *
   * @param dsCaTruc2
   */
  private void UpdataCaLam(List<ChiTietCaTruc> dsCaTruc2) {
    String[] arrTen = { "Ca 1:7h-11h", "Ca 2:12h-17h", "Ca 3:18h-22h" };
    cmbCaLam.setModel(new DefaultComboBoxModel<String>(arrTen));
    cmbCaLam.updateUI();
  }

  /**
   * loadata combobox nhân viên
   *
   * @param dsCaTruc2
   */
  private void UpdataComboboxNhanVien() {
    comboBoxNhanVien.removeAll();

    List<String> dsTenNV = new ArrayList<>();
    for (NhanVien nv : nhanVienImp.dsNV()) {
      dsTenNV.add(nv.getTenNV().trim());
    }
    String[] arrTen = new String[dsTenNV.size()];
    dsTenNV.toArray(arrTen);
    comboBoxNhanVien.setModel(new DefaultComboBoxModel<String>(arrTen));
    comboBoxNhanVien.updateUI();
  }

  /**
   * tạo bảng danh sách ca trực
   */
  void CreateTable() {
    String header[] = { "Ca trực", "Tên nhân viên", "Thời gian", "Ngày" };
    tableModelPhanCongCaLam = new DefaultTableModel(header, 0);
    dsCaTruc = caLamService.getDanhSachCTCaTruc();

    tablePhanCongCaLam = new JTable(tableModelPhanCongCaLam);
    tablePhanCongCaLam.addMouseListener(this);
    JLabel lblTenTable = new JLabel("Danh sách ca trực: ");
    lblTenTable.setBounds(80, 190, 200, 30);
    tablePhanCongCaLam.setDefaultEditor(Object.class, null);
    DefaultTableCellRenderer centerRenderer = new DefaultTableCellRenderer();
    centerRenderer.setHorizontalAlignment(JLabel.CENTER);
    tablePhanCongCaLam.getColumnModel().getColumn(0).setCellRenderer(centerRenderer);
    tablePhanCongCaLam.getColumnModel().getColumn(1).setCellRenderer(centerRenderer);
    tablePhanCongCaLam.getColumnModel().getColumn(2).setCellRenderer(centerRenderer);
    tablePhanCongCaLam.getColumnModel().getColumn(3).setCellRenderer(centerRenderer);

    JScrollPane scrollPane = new JScrollPane(tablePhanCongCaLam);
    scrollPane.setBounds(80, 220, 1380, 350);

    dsCaTruc = caLamService.getDanhSachCTCaTruc();
    pnlCenter.add(lblTenTable);
    pnlCenter.add(scrollPane);
  }

  /**
   * loadata bảng danh sách ca trực
   *
   * @param dsCT
   */
  private void UpdataTable() {
    tableModelPhanCongCaLam.setRowCount(0);
    // format ngayphanca

    for (ChiTietCaTruc caTruc : caLamService.getDanhSachCTCaTruc()) {
      String formatCaTruc = caTruc.getNgayPhanCa().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
      String[] rowStrings = { caTruc.getCaTruc().getMaCaTruc(), caTruc.getNv().getTenNV(),
          caTruc.getCaTruc().getThoiGianCaTruc(), formatCaTruc };
      tableModelPhanCongCaLam.addRow(rowStrings);
    }
    tablePhanCongCaLam.setModel(tableModelPhanCongCaLam);
    tablePhanCongCaLam.updateUI();
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    try {
      if (e.getSource() == btnPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnKhachHang) {
        new QuanLyKhachHang(tk, "").setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnNhanVien) {
        new QLNhanVien(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnThongke) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnQuanLyDatPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconUser) {
        new ThongTinNguoiDung(tk).setVisible(true);
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnIconLogout) {
        int tb = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn đăng xuất không", "Cảnh báo",
            JOptionPane.YES_NO_OPTION);
        if (tb == JOptionPane.YES_OPTION) {
          new DangNhap().setVisible(true);
          this.dispose();
        }
      } else if (e.getSource() == btnHoaDon) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      }
    } catch (MalformedURLException e1) {
      e1.printStackTrace();
    }

    if (e.getSource() == btnLuu) {
      SuaCaLam();
      UpdataTable();
    } else if (e.getSource() == btnXoa) {
      if (btnXoa.getText().equals("Xóa"))
        DeleteRow();
      else if (btnXoa.getText().equals("Hủy")) {
        btnLuu.setText("Sửa");
        btnLuu.setBackground(Color.orange);
        btnLuu.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));

        btnXoa.setText("Xóa");
        btnXoa.setBackground(Color.white);
        btnXoa.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
      }
    } else if (e.getSource() == btnTim) {
      TimCaTruc();
    } else if (e.getSource() == btnThem) {
      ThemCaTruc();
      XoaRong();
      UpdataTable();
    } else if (e.getSource() == btnRefresh) {
      UpdataTable();
      XoaRong();
    } else if (e.getSource() == btnXuatFile) {
      exportExcelFile();
    }
  }

  public void exportExcelFile() {
    JFileChooser chooser = new JFileChooser();
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Excel File", "xlsx");
    chooser.setFileFilter(filter);
    chooser.setDialogTitle("Save as");
    chooser.setAcceptAllFileFilterUsed(false);
    if (chooser.showSaveDialog(null) == JFileChooser.APPROVE_OPTION) {
      try {
        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
          XSSFSheet spreadsheet = workbook.createSheet("ThốngKê");
          XSSFRow row = spreadsheet.createRow(0);
          for (int j = 0; j < tablePhanCongCaLam.getColumnCount(); j++) {
            XSSFCell cell = row.createCell(j);
            cell.setCellValue(tablePhanCongCaLam.getColumnName(j));
          }
          for (int i = 0; i < tablePhanCongCaLam.getRowCount(); i++) {
            row = spreadsheet.createRow(i + 1);
            for (int j = 0; j < tablePhanCongCaLam.getColumnCount(); j++) {
              XSSFCell cell = row.createCell(j);

              cell.setCellValue(tableModelPhanCongCaLam.getValueAt(i, j).toString());

            }
          }
          File file = new File(chooser.getSelectedFile() + ".xlsx");
          if (file.exists()) {
            int result = JOptionPane.showConfirmDialog(null, "File đã tồn tại, bạn có muốn ghi đè không?",
                "Thông báo", JOptionPane.YES_NO_OPTION);
            int xemFile = JOptionPane.showConfirmDialog(null, "Xuất file thành công. Bạn có muốn xem file không?",
                "Thông báo", JOptionPane.YES_NO_OPTION);

            if (result == JOptionPane.YES_OPTION) {
              file.delete();
              file.createNewFile();
              OutputStream os = new FileOutputStream(file);
              workbook.write(os);
              os.close();
              if (xemFile == JOptionPane.YES_OPTION) {
                Desktop.getDesktop().open(file);
              }
            }
          } else {
            int xemFile = JOptionPane.showConfirmDialog(null, "Xuất file thành công. Bạn có muốn xem file không?",
                "Thông báo", JOptionPane.YES_NO_OPTION);
            file.createNewFile();
            OutputStream os = new FileOutputStream(file);
            workbook.write(os);
            os.close();
            if (xemFile == JOptionPane.YES_OPTION) {
              Desktop.getDesktop().open(file);
            }
          }
        } catch (HeadlessException e) {
          e.printStackTrace();
        }
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  private void TimCaTruc() {
    List<ChiTietCaTruc> ds = new ArrayList<>();
    String thoiGianTruc = cmbLocTheoCa.getSelectedItem().toString().split(":")[1].trim();
    String tenNV = cmbLocTenNhanVien.getSelectedItem().toString().trim();
    try {
      LocalDate date = txtDate.getDate();
      int op = cmbLocOption.getSelectedIndex();
      ds = caLamService.timDanhSaChiTietCaTrucs(op, date, thoiGianTruc, tenNV);
      if (ds.size() == 0) {
        if (op == 0) {
          JOptionPane.showMessageDialog(this, "Không có ca trực cho ngày:" + date);
          XoaRong();
        } else if (op == 1) {
          JOptionPane.showMessageDialog(this, "Không có ca trực cho ca:" + thoiGianTruc);
          XoaRong();
        } else if (op == 2) {
          JOptionPane.showMessageDialog(this, "Không có ca trực cho nhân viên:" + tenNV);
          XoaRong();
        }
      } else {
        UpdataTableTim(ds);
        XoaRong();
      }
    } catch (Exception e) {
      JOptionPane.showMessageDialog(null, "Chưa chọn ngày phân công");
    }
  }

  private void UpdataTableTim(List<ChiTietCaTruc> ds) {
    tableModelPhanCongCaLam.setRowCount(0);

    for (ChiTietCaTruc caTruc : ds) {
      String[] rowStrings = { caTruc.getCaTruc().getMaCaTruc(), caTruc.getNv().getTenNV(),
          caTruc.getCaTruc().getThoiGianCaTruc(), caTruc.getNgayPhanCa().toString() };
      tableModelPhanCongCaLam.addRow(rowStrings);
    }
    tablePhanCongCaLam.setModel(tableModelPhanCongCaLam);
    tablePhanCongCaLam.updateUI();
  }

  /**
   * thêm 1 ca trực
   *
   * @throws Exception
   */
  private void ThemCaTruc() {
    txtNgay.setEnabled(true);
    String maCaTruc = InitMaCaTruc();
    if (maCaTruc.equals("")) {
      JOptionPane.showMessageDialog(null, "Chưa chọn ngày phân công");
    } else {
      String thoiGianTruc = cmbCaLam.getSelectedItem().toString().split(":")[1].trim();

      CaTruc caTruc = new CaTruc(maCaTruc, thoiGianTruc);
      if (kiemTraTrungCaTruc(caTruc) == true) {
      } else {
        caLamService.themCaTruc(caTruc);
      }

      ChiTietCaTruc chiTietCaTruc = new ChiTietCaTruc(txtNgay.getDate(), "true");
      for (NhanVien nv : nhanVienImp.dsNV()) {
        if (nv.getTenNV().trim().equals(comboBoxNhanVien.getSelectedItem().toString().trim())) {
          chiTietCaTruc.setNv(nv);
        }
      }

      chiTietCaTruc.setCaTruc(caTruc);
      if (kiemTraTrungCa(chiTietCaTruc)) {
        JOptionPane.showMessageDialog(null, "Thêm thất bại,ca trực bị trùng");
      } else {
        caLamService.themChiTietCaTruc(chiTietCaTruc);
        JOptionPane.showMessageDialog(null, "Thêm ca trực thành công");
      }
    }
  }

  private boolean kiemTraTrungCa(ChiTietCaTruc chiTietCaTruc) {
    boolean kt = false;
    for (ChiTietCaTruc ct : caLamService.getDanhSachCTCaTruc()) {
      if (ct.getNv().getMaNV().trim().equals(chiTietCaTruc.getNv().getMaNV().trim())
          && ct.getCaTruc().getMaCaTruc().trim().equals(chiTietCaTruc.getCaTruc().getMaCaTruc().trim())) {
        return true;
      } else {
        kt = false;
      }

    }
    return kt;
  }

  private boolean kiemTraTrungCaTruc(CaTruc caTruc) {
    boolean kt = true;
    if (caLamService.getDanhSachCaTruc().size() > 0) {
      for (CaTruc ca : caLamService.getDanhSachCaTruc()) {
        if (ca.getMaCaTruc().trim().equals(caTruc.getMaCaTruc().trim())) {
          kt = true;
          break;
        } else
          kt = false;
      }
    } else {
      kt = false;
    }
    return kt;
  }

  private void SuaCaLam() {
    int row = tablePhanCongCaLam.getSelectedRow();

    if (row == -1) {
      JOptionPane.showMessageDialog(this, "Chưa chọn ca trực để xóa");
    } else {
      txtNgay.setEnabled(true);
      String maCaTruc = InitMaCaTruc();
      String thoiGianTruc = cmbCaLam.getSelectedItem().toString().trim();

      CaTruc caTruc = new CaTruc(maCaTruc, thoiGianTruc);
      if (kiemTraTrungCaTruc(caTruc) == true) {
      } else {
        caLamService.themCaTruc(caTruc);
      }

      ChiTietCaTruc chiTietCaTruc = new ChiTietCaTruc(txtNgay.getDate(), "true");
      for (NhanVien nv : nhanVienImp.dsNV()) {
        if (nv.getTenNV().trim().equals(comboBoxNhanVien.getSelectedItem().toString().trim())) {
          chiTietCaTruc.setNv(nv);
        }
      }

      chiTietCaTruc.setCaTruc(caTruc);
      if (kiemTraTrungCa(chiTietCaTruc)) {
        JOptionPane.showMessageDialog(null, "Trùng ca trực");
      } else {
        String tenNVs = tableModelPhanCongCaLam.getValueAt(row, 1).toString().trim();
        String maCaTrucs = tableModelPhanCongCaLam.getValueAt(row, 0).toString().trim();
        String maNVs = "";
        for (NhanVien nv : nhanVienImp.dsNV()) {
          if (nv.getTenNV().equals(tenNVs))
            maNVs = nv.getMaNV();
        }
        caLamService.capNhatChiTietCaTruc(chiTietCaTruc, maCaTrucs, maNVs);
        JOptionPane.showMessageDialog(null, "Sửa ca trực thành công");
      }
    }
  }

  private String InitMaCaTruc() {
    int caLam = cmbCaLam.getSelectedIndex();
    String maCaTruc = "";
    if (txtNgay.getDate() != null) {
      LocalDate ngayPhanCong = txtNgay.getDate();
      maCaTruc = new Generator().tuTaoMaCaTruc(ngayPhanCong, caLam).trim();
    }
    return maCaTruc;
  }

  /**
   * hàm xóa ca trực
   */
  private void DeleteRow() {
    try {
      int i = JOptionPane.showConfirmDialog(this, "Bạn chắc muốn xóa ca trực này?", "Cảnh báo",
          JOptionPane.YES_NO_OPTION);
      if (i == JOptionPane.YES_OPTION) {
        int row = tablePhanCongCaLam.getSelectedRow();
        String tenNV = tableModelPhanCongCaLam.getValueAt(row, 1).toString().trim();
        String maCaTruc = tableModelPhanCongCaLam.getValueAt(row, 0).toString().trim();
        String maNV = "";

        for (NhanVien nv : nhanVienImp.dsNV()) {
          if (nv.getTenNV().equals(tenNV))
            maNV = nv.getMaNV();
        }
        tableModelPhanCongCaLam.removeRow(row);
        caLamService.xoaChiTietCaTruc(maCaTruc, maNV);
        UpdataTable();
      }
    } catch (Exception e) {
      JOptionPane.showMessageDialog(this, "Bạn chưa chọn ca trực để xóa!");
    }
  }

  /**
   * xóa rỗng
   */
  private void XoaRong() {
    txtNgay.setText("");
    txtDate.setText("");
    cmbCaLam.setSelectedIndex(0);
    comboBoxNhanVien.setSelectedIndex(0);
  }

  /**
   * event click chuột
   */
  @Override
  public void mouseClicked(MouseEvent e) {
    int row = tablePhanCongCaLam.getSelectedRow();
    String nameString = tableModelPhanCongCaLam.getValueAt(row, 1).toString();

    comboBoxNhanVien.setSelectedItem(nameString);

    String caTrucString = tableModelPhanCongCaLam.getValueAt(row, 2).toString().trim();

    if (caTrucString.equals("7h-11h")) {
      cmbCaLam.setSelectedIndex(0);
    }
    if (caTrucString.equals("12h-17h")) {
      cmbCaLam.setSelectedIndex(1);
    }
    if (caTrucString.equals("18h-22h")) {
      cmbCaLam.setSelectedIndex(2);
    }
    txtNgay
        .setText(generator.parseLocaldateToDatetimepicker(tablePhanCongCaLam.getValueAt(row, 3).toString()));
    // String ngayTrucString = tableModelPhanCongCaLam.getValueAt(row,
    // 3).toString();
    // LocalDate localDate1 = LocalDate.parse(ngayTrucString,
    // DateTimeFormatter.ofPattern("yyyy-MM-dd"));
    // txtNgay.setDate(localDate1);
  }

  @Override
  public void mousePressed(MouseEvent e) {
    // TODO Auto-generated method stub

  }

  @Override
  public void mouseReleased(MouseEvent e) {
    // TODO Auto-generated method stub

  }

  @Override
  public void mouseEntered(MouseEvent e) {
    // TODO Auto-generated method stub

  }

  @Override
  public void mouseExited(MouseEvent e) {
    // TODO Auto-generated method stub

  }

}