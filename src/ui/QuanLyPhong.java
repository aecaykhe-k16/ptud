package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.HeadlessException;
import java.awt.Frame;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.DefaultComboBoxModel;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
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
import javax.swing.border.TitledBorder;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import bus.IDangNhapService;
import bus.IPhanCongCaLamService;
import bus.IPhongService;
import bus.implement.DangNhapImp;
import bus.implement.PhanCongCaLamImp;
import bus.implement.PhongImp;
import entities.LoaiPhongEnum;
import entities.Phong;
import entities.TaiKhoan;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.Generator;
import util.MyButton;
import util.PlaceholderTextField;
import util.SpecialButton;

public class QuanLyPhong extends JFrame implements ActionListener, MouseListener {

  private JLabel lblIconLogo, lblTitle, lblDanhSachCaLam;
  private JButton btnIconUser, btnIconLogout;
  private Cursor handCursor;

  private JPanel pnlMenu, pnlTop, pnInfo, pnlBtn, pnlMainUI, pnlMain, pnlPhong, pnlSubBtn;
  private JButton btnThem, btnXoa, btnSua, btnTimKiem, btnImportFile, btnExportFile, btnRefresh, btnClearForm,
      btnHuySua;

  private PlaceholderTextField txtTimKiem;
  private String maPhong;

  // slidebar
  private JButton btnNhanVien, btnPhong, btnKhachHang, btnThongke, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnDichVu, btnHoaDon;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu, lblHoaDon;
  private JLayeredPane layeredPane;
  private boolean flagSua = false;

  // Thêm phòng
  private JPanel pnlThemPhong;
  private JTextField txtChieuRong, txtChieuDai, txtTV, txtTenPhong, txtBan, txtTenSoFa;
  private DefaultComboBoxModel<String> modelLoaiPhong, modelSucChua, modelSLSofa, modelSLLoa;
  private JComboBox<String> cmbLoaiPhong, cmbSucChua, cmbSLSofa, cmbSLLoa;
  private JLabel lblChieuRong, lblchieuDai, lblSucChua, lblTV, lblTenPhong, lblBan, lblTenSoFa, lblSLSofa, lblSLLoa,
      lblLoaiPhong;

  // danh sách phòng
  private JPanel pnlDanhSachPhong;
  private DefaultTableModel modelDanhSachPhong;
  private JTable tblDanhSachPhong;

  // service
  private IPhongService phongService = new PhongImp();
  private Generator gen = new Generator();
  private IDangNhapService dangNhap = new DangNhapImp();
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();
  private TaiKhoan tk;
  // entities
  private Phong phong;

  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);

  public QuanLyPhong(TaiKhoan taiKhoan) throws MalformedURLException {

    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;

    pnlPhong = new JPanel();
    pnlPhong.setLayout(null);
    pnlPhong.setBackground(null);
    pnlPhong.setBounds(25, 20, 700, 100);
    this.setIconImage(imageIcon);
    this.setDefaultCloseOperation(EXIT_ON_CLOSE);
    setExtendedState(MAXIMIZED_BOTH);
    this.setMinimumSize(new Dimension(1500, 800));
    this.setLocationRelativeTo(null);
    this.setLayout(null);
    this.setTitle("Phòng");
    layeredPane = new JLayeredPane();
    layeredPane.setBounds(0, 0, 2000, 1500);
    add(layeredPane);

    pnlMainUI = new JPanel();
    pnlMainUI.setLayout(null);
    pnlMainUI.setBounds(0, 0, 2000, 1400);
    handCursor = new Cursor(Cursor.HAND_CURSOR);
    PnlTop();
    PnlMenu();
    PnlCenter();
    layeredPane.add(pnlMainUI, 1);

    loadData();

    // keybinding
    btnThem.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F1, 0),
        "btnThem");
    btnThem.getActionMap().put("btnThem", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnThem.doClick();
      }
    });
    btnSua.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F2, 0),
        "btnSua");
    btnSua.getActionMap().put("btnSua", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnSua.doClick();
      }
    });
    btnXoa.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F3, 0),
        "btnXoa");
    btnXoa.getActionMap().put("btnXoa", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnXoa.doClick();
      }
    });
    btnHuySua.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F4, 0),
        "btnHuySua");
    btnHuySua.getActionMap().put("btnHuySua", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnHuySua.doClick();
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
    btnExportFile.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F6, 0),
        "btnExportFile");
    btnExportFile.getActionMap().put("btnExportFile", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnExportFile.doClick();
      }
    });
    btnImportFile.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F7, 0),
        "btnImportFile");
    btnImportFile.getActionMap().put("btnImportFile", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnImportFile.doClick();
      }
    });
    btnClearForm.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_F8, 0),
        "btnClearForm");
    btnClearForm.getActionMap().put("btnClearForm", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnClearForm.doClick();
      }
    });
    btnTimKiem.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER, 0),
        "btnTimKiem");
    btnTimKiem.getActionMap().put("btnTimKiem", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnTimKiem.doClick();
      }
    });

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
      btnPhong.setIcon(FontIcon.of(FontAwesomeSolid.DOOR_CLOSED, 30, Color.decode("#7743DB")));
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

  private void PnlCenter() {

    pnlMain = new JPanel();
    pnlMain.setBounds(0, 155, 1800, 800);
    pnlMain.setLayout(null);
    pnlMain.setBackground(Color.decode(Constants.MAIN_COLOR));
    pnlThemPhong();
    DsPhong();
    PnlBtn();
    PnlSubBtn();
    pnlMainUI.add(pnlMain);

  }

  private void pnlThemPhong() {

    Font font = new Font(Constants.MAIN_FONT, Font.PLAIN, 20);
    pnlThemPhong = new JPanel();
    pnlThemPhong.setBounds(10, 10, 1200, 240);
    pnlThemPhong.setLayout(null);

    pnlThemPhong.setBackground(Color.decode(Constants.MAIN_COLOR));

    lblChieuRong = new JLabel("Chiều rộng");
    lblChieuRong.setBounds(20, 20, 100, 30);
    lblChieuRong.setFont(font);
    pnlThemPhong.add(lblChieuRong);

    txtChieuRong = new JTextField();
    txtChieuRong.setBounds(120, 20, 400, 30);
    txtChieuRong.setFont(font);
    txtChieuRong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtChieuRong);

    lblchieuDai = new JLabel("Chiều cao");
    lblchieuDai.setBounds(20, 60, 100, 30);
    lblchieuDai.setFont(font);
    pnlThemPhong.add(lblchieuDai);

    txtChieuDai = new JTextField();
    txtChieuDai.setBounds(120, 60, 400, 30);
    txtChieuDai.setFont(font);
    txtChieuDai.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtChieuDai);

    lblTV = new JLabel("Tivi");
    lblTV.setBounds(20, 100, 100, 30);
    lblTV.setFont(font);
    pnlThemPhong.add(lblTV);

    txtTV = new JTextField();
    txtTV.setBounds(120, 100, 400, 30);
    txtTV.setFont(font);
    txtTV.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtTV);

    lblBan = new JLabel("Bàn");
    lblBan.setBounds(20, 140, 100, 30);
    lblBan.setFont(font);
    pnlThemPhong.add(lblBan);

    txtBan = new JTextField();
    txtBan.setBounds(120, 140, 400, 30);
    txtBan.setFont(font);
    txtBan.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtBan);

    lblTenPhong = new JLabel("Tên phòng");
    lblTenPhong.setBounds(20, 180, 100, 30);
    lblTenPhong.setFont(font);
    pnlThemPhong.add(lblTenPhong);

    txtTenPhong = new JTextField();
    txtTenPhong.setBounds(120, 180, 400, 30);
    txtTenPhong.setFont(font);
    txtTenPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtTenPhong);

    lblTenSoFa = new JLabel("Tên sofa");
    lblTenSoFa.setBounds(630, 20, 100, 30);
    lblTenSoFa.setFont(font);
    pnlThemPhong.add(lblTenSoFa);

    txtTenSoFa = new JTextField();
    txtTenSoFa.setBounds(780, 20, 400, 30);
    txtTenSoFa.setFont(font);
    txtTenSoFa.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(txtTenSoFa);

    lblLoaiPhong = new JLabel("Loại phòng");
    lblLoaiPhong.setBounds(630, 60, 130, 30);
    lblLoaiPhong.setFont(font);
    pnlThemPhong.add(lblLoaiPhong);

    modelLoaiPhong = new DefaultComboBoxModel<String>();
    for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
      modelLoaiPhong.addElement(t.getLoaiPhong());
    }
    cmbLoaiPhong = new JComboBox<String>(modelLoaiPhong);
    cmbLoaiPhong.setBounds(780, 60, 400, 30);
    cmbLoaiPhong.setFont(font);
    cmbLoaiPhong.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(cmbLoaiPhong);

    lblSucChua = new JLabel("Sức chứa");
    lblSucChua.setBounds(630, 100, 130, 30);
    lblSucChua.setFont(font);
    pnlThemPhong.add(lblSucChua);

    modelSucChua = new DefaultComboBoxModel<String>();
    modelSucChua.addElement("10");
    modelSucChua.addElement("2");
    modelSucChua.addElement("15");
    modelSucChua.addElement("20");
    modelSucChua.addElement("25");
    modelSucChua.addElement("30");
    cmbSucChua = new JComboBox<String>(modelSucChua);
    cmbSucChua.setBounds(780, 100, 400, 30);
    cmbSucChua.setFont(font);
    cmbSucChua.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(cmbSucChua);

    lblSLSofa = new JLabel("Số lượng sofa");
    lblSLSofa.setBounds(630, 140, 130, 30);
    lblSLSofa.setFont(font);
    pnlThemPhong.add(lblSLSofa);

    modelSLSofa = new DefaultComboBoxModel<String>();
    modelSLSofa.addElement("1");
    modelSLSofa.addElement("2");
    modelSLSofa.addElement("3");
    modelSLSofa.addElement("4");
    cmbSLSofa = new JComboBox<String>(modelSLSofa);
    cmbSLSofa.setBounds(780, 140, 400, 30);
    cmbSLSofa.setFont(font);
    cmbSLSofa.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(cmbSLSofa);

    lblSLLoa = new JLabel("Số lượng loa");
    lblSLLoa.setBounds(630, 180, 130, 30);
    lblSLLoa.setFont(font);
    pnlThemPhong.add(lblSLLoa);

    modelSLLoa = new DefaultComboBoxModel<String>();
    modelSLLoa.addElement("1");
    modelSLLoa.addElement("2");
    modelSLLoa.addElement("3");
    modelSLLoa.addElement("4");
    cmbSLLoa = new JComboBox<String>(modelSLLoa);
    cmbSLLoa.setBounds(780, 180, 400, 30);
    cmbSLLoa.setFont(font);
    cmbSLLoa.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlThemPhong.add(cmbSLLoa);

    pnlMain.add(pnlThemPhong);

    cmbLoaiPhong.addActionListener(this);
    cmbSucChua.addActionListener(this);
    cmbSLSofa.addActionListener(this);
    cmbSLLoa.addActionListener(this);

  }

  private void PnlBtn() {
    pnlBtn = new JPanel();
    TitledBorder title = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Chức năng chính");
    pnlBtn.setBorder(title);
    pnlBtn.setBounds(1220, 10, 310, 240);
    pnlBtn.setLayout(null);
    pnlBtn.setBackground(Color.decode(Constants.MAIN_COLOR));
    txtTimKiem = new PlaceholderTextField(Color.GRAY, false);
    txtTimKiem.setPlaceholder("Nhập tên phòng");
    txtTimKiem.setBounds(10, 20, 190, 30);
    txtTimKiem.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    txtTimKiem.setBorder(null);
    txtTimKiem.setBackground(Color.decode(Constants.INPUT_COLOR));
    pnlBtn.add(txtTimKiem);

    btnTimKiem = new SpecialButton(10, Color.decode(Constants.MAIN_COLOR), Color.WHITE);
    btnTimKiem.setBounds(205, 20, 90, 30);
    btnTimKiem.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnTimKiem.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));
    btnTimKiem.setBorder(null);
    btnTimKiem.setBorderPainted(false);
    btnTimKiem.setFocusPainted(false);
    btnTimKiem.setCursor(handCursor);
    pnlBtn.add(btnTimKiem);

    btnThem = new MyButton(10, Color.GREEN, Color.GREEN);
    btnThem.setText("Thêm (F1)");
    btnThem.setBounds(10, 60, 290, 35);
    btnThem.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnThem.setIcon(FontIcon.of(FontAwesomeSolid.PLUS, 20));
    btnThem.setBorder(null);
    btnThem.setBorderPainted(false);
    btnThem.setFocusPainted(false);
    btnThem.setCursor(handCursor);
    pnlBtn.add(btnThem);

    btnSua = new MyButton(10, Color.ORANGE, Color.ORANGE);
    btnSua.setText("Sửa (F2)");
    btnSua.setBounds(10, 105, 290, 35);
    btnSua.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnSua.setIcon(FontIcon.of(FontAwesomeSolid.EDIT, 20));
    btnSua.setBorder(null);
    btnSua.setBorderPainted(false);
    btnSua.setFocusPainted(false);
    btnSua.setCursor(handCursor);
    pnlBtn.add(btnSua);
    pnlMain.add(pnlBtn);

    btnXoa = new MyButton(10, Color.WHITE, Color.WHITE);
    btnXoa.setText("Xóa (F3)");
    btnXoa.setBounds(10, 150, 290, 35);
    btnXoa.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnXoa.setIcon(FontIcon.of(FontAwesomeSolid.TRASH_ALT, 20, Color.RED));
    btnXoa.setBorder(null);
    btnXoa.setBorderPainted(false);
    btnXoa.setFocusPainted(false);
    btnXoa.setCursor(handCursor);
    pnlBtn.add(btnXoa);

    btnHuySua = new MyButton(10, Color.WHITE, Color.WHITE);
    btnHuySua.setText("Hủy sửa (F4)");
    btnHuySua.setBounds(10, 195, 290, 35);
    btnHuySua.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    btnHuySua.setBorder(null);
    btnHuySua.setBorderPainted(false);
    btnHuySua.setFocusPainted(false);
    btnHuySua.setCursor(handCursor);
    btnHuySua.setEnabled(false);
    pnlBtn.add(btnHuySua);

    btnThem.addActionListener(this);
    btnXoa.addActionListener(this);
    btnSua.addActionListener(this);
    btnHuySua.addActionListener(this);
    btnTimKiem.addActionListener(this);
  }

  private void PnlSubBtn() {
    pnlSubBtn = new JPanel();
    pnlSubBtn.setBounds(1220, 260, 310, 360);
    TitledBorder title = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Chức năng khác");
    pnlSubBtn.setBorder(title);
    pnlSubBtn.setLayout(null);
    pnlSubBtn.setBackground(Color.decode(Constants.MAIN_COLOR));

    btnRefresh = new MyButton(10, Color.WHITE, Color.WHITE);
    btnRefresh.setText("Làm mới (F5)");
    btnRefresh.setBounds(10, 40, 290, 30);
    btnRefresh.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 25));
    btnRefresh.setBorder(null);
    btnRefresh.setBorderPainted(false);
    btnRefresh.setFocusPainted(false);
    btnRefresh.setCursor(handCursor);
    pnlSubBtn.add(btnRefresh);

    btnExportFile = new MyButton(10, Color.WHITE, Color.WHITE);
    btnExportFile.setText("Xuất file (F6)");
    btnExportFile.setBounds(10, 90, 290, 40);
    btnExportFile.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 25));
    btnExportFile.setBorder(null);
    btnExportFile.setBorderPainted(false);
    btnExportFile.setFocusPainted(false);
    btnExportFile.setCursor(handCursor);
    pnlSubBtn.add(btnExportFile);

    btnImportFile = new MyButton(10, Color.WHITE, Color.WHITE);
    btnImportFile.setText("Nhập file (F7)");
    btnImportFile.setBounds(10, 150, 290, 40);
    btnImportFile.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 25));
    btnImportFile.setBorder(null);
    btnImportFile.setBorderPainted(false);
    btnImportFile.setFocusPainted(false);
    btnImportFile.setCursor(handCursor);
    pnlSubBtn.add(btnImportFile);

    btnClearForm = new MyButton(10, Color.WHITE, Color.WHITE);
    btnClearForm.setText("Xóa form (F8)");
    btnClearForm.setBounds(10, 210, 290, 40);
    btnClearForm.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 25));
    btnClearForm.setBorder(null);
    btnClearForm.setBorderPainted(false);
    btnClearForm.setFocusPainted(false);
    btnClearForm.setCursor(handCursor);
    pnlSubBtn.add(btnClearForm);

    pnlMain.add(pnlSubBtn);

    btnRefresh.addActionListener(this);
    btnExportFile.addActionListener(this);
    btnImportFile.addActionListener(this);
    btnClearForm.addActionListener(this);

  }

  private void DsPhong() {

    pnlDanhSachPhong = new JPanel();
    pnlDanhSachPhong.setBounds(10, 260, 1200, 360);
    TitledBorder title = new TitledBorder(BorderFactory.createLineBorder(Color.black), "Danh sách phòng");

    pnlDanhSachPhong.setBorder(title);
    pnlDanhSachPhong.setLayout(null);
    pnlDanhSachPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
    String[] header = { "Mã phòng", "Tên phòng", "Sức chứa", "Số lượng sofa", "Số lượng loa", "Ti vi",
        "Loại phòng",
        "Chiều rộng", "Giá phòng", "Chiều cao", "Bàn", "Tên sofa" };
    modelDanhSachPhong = new DefaultTableModel(header, 0);
    tblDanhSachPhong = new JTable(modelDanhSachPhong);
    tblDanhSachPhong.getColumnModel().getColumn(0).setMinWidth(0);
    tblDanhSachPhong.getColumnModel().getColumn(0).setMaxWidth(0);
    tblDanhSachPhong.getColumnModel().getColumn(0).setWidth(0);
    tblDanhSachPhong.getColumnModel().getColumn(2).setMinWidth(70);
    tblDanhSachPhong.getColumnModel().getColumn(2).setMaxWidth(70);

    tblDanhSachPhong.setDefaultEditor(Object.class, null);
    tblDanhSachPhong.setRowHeight(30);
    tblDanhSachPhong.setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 20));
    tblDanhSachPhong.setBackground(Color.decode(Constants.MAIN_COLOR));
    tblDanhSachPhong.getTableHeader().setFont(new Font(Constants.MAIN_FONT, Font.PLAIN, 13));
    tblDanhSachPhong.getTableHeader().setPreferredSize(new Dimension(0, 30));
    tblDanhSachPhong.getTableHeader().setBackground(Color.decode(Constants.MAIN_COLOR));

    JScrollPane scroll = new JScrollPane(tblDanhSachPhong);
    scroll.setBounds(10, 20, 1180, 330);
    pnlDanhSachPhong.add(scroll);
    pnlMain.add(pnlDanhSachPhong);

    tblDanhSachPhong.addMouseListener(this);
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    try {
      if (e.getSource() == btnKhachHang) {
        new QuanLyKhachHang(tk, "").setVisible(true);
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
      } else if (e.getSource() == btnQuanLyDatPhong) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnDichVu) {
        new DichVuUI(tk).setVisible(true);
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
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      }
    } catch (Exception e1) {
      e1.printStackTrace();
    }

    if (e.getSource() == btnThem) {
      themPhong();
    } else if (e.getSource() == btnXoa) {
      xoaPhong();
      xoaTrang();
      if (flagSua == true && btnSua.getText().startsWith("Lưu")) {
        cmbLoaiPhong.setEnabled(false);
        btnHuySua.setEnabled(true);
        btnThem.setEnabled(false);
      }
    } else if (e.getSource() == btnSua) {
      if (flagSua == false && btnSua.getText().startsWith("Sửa")) {
        // disable cmbLoaiPhong
        cmbLoaiPhong.setEnabled(false);
        btnHuySua.setEnabled(true);
        btnThem.setEnabled(false);
        btnSua.setText("Lưu (F2)");
        flagSua = true;
      } else {
        suaPhong();

      }

    } else if (e.getSource() == btnHuySua) {
      if (flagSua == true && btnSua.getText().startsWith("Lưu")) {
        btnSua.setText("Sửa (F2)");
        flagSua = false;
        btnHuySua.setEnabled(false);
        btnThem.setEnabled(true);
        cmbLoaiPhong.setEnabled(true);
        // unfocus table
        tblDanhSachPhong.clearSelection();
        xoaTrang();
      }

    } else if (e.getSource() == btnClearForm) {
      // un focuse table
      int thongBao = JOptionPane.showConfirmDialog(null, "Bạn có chắc chắn muốn xóa nội dung ở form không?",
          "Thông báo",
          JOptionPane.YES_NO_OPTION);
      if (thongBao == JOptionPane.YES_OPTION) {
        tblDanhSachPhong.clearSelection();
        xoaTrang();
      }
    } else if (e.getSource() == btnRefresh) {
      loadData();
    } else if (e.getSource() == btnTimKiem) {
      timKiem();
    } else if (e.getSource() == btnExportFile) {
      exportExcelFile();
    } else if (e.getSource() == btnImportFile) {
      if (btnImportFile.getText().startsWith("Nhập file (F7)")) {
        importExcel();
      } else {
        btnImportFile.setText("Nhập file (F7)");
        for (int i = 0; i < tblDanhSachPhong.getRowCount(); i++) {
          String ma = tblDanhSachPhong.getValueAt(i, 0).toString();
          String ten = tblDanhSachPhong.getValueAt(i, 1).toString();
          int sucChua = Integer.parseInt(tblDanhSachPhong.getValueAt(i, 2).toString());
          int slSofa = Integer.parseInt(tblDanhSachPhong.getValueAt(i, 3).toString());
          int slLoa = Integer.parseInt(tblDanhSachPhong.getValueAt(i, 4).toString());
          String tv = tblDanhSachPhong.getValueAt(i, 5).toString();
          LoaiPhongEnum loaiPhong = tblDanhSachPhong.getValueAt(i, 6).toString().startsWith("T") ? LoaiPhongEnum.THUONG
              : LoaiPhongEnum.VIP;
          double chieuRong = Double.parseDouble(tblDanhSachPhong.getValueAt(i, 7).toString().split(" ")[0]);
          double giaPhong = Double.parseDouble(tblDanhSachPhong.getValueAt(i, 8).toString());
          double chieuDai = Double.parseDouble(tblDanhSachPhong.getValueAt(i, 9).toString().split(" ")[0]);
          String ban = tblDanhSachPhong.getValueAt(i, 10).toString();
          String sofa = tblDanhSachPhong.getValueAt(i, 11).toString();

          Phong p = new Phong(ma, ten, giaPhong, sucChua, chieuRong, chieuDai, tv, ban, sofa, slSofa, slLoa,
              TrangThaiPhongEnum.TRONG, loaiPhong);
          phongService.themPhong(p);
        }
      }
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
          XSSFSheet spreadsheet = workbook.createSheet("Danh sách phòng");
          XSSFRow row = spreadsheet.createRow(0);
          for (int j = 0; j < tblDanhSachPhong.getColumnCount(); j++) {
            XSSFCell cell = row.createCell(j);
            cell.setCellValue(tblDanhSachPhong.getColumnName(j));
          }
          for (int i = 0; i < tblDanhSachPhong.getRowCount(); i++) {
            row = spreadsheet.createRow(i + 1);
            for (int j = 0; j < tblDanhSachPhong.getColumnCount(); j++) {
              XSSFCell cell = row.createCell(j);
              if (tblDanhSachPhong.getValueAt(i, j) instanceof Integer
                  || tblDanhSachPhong.getValueAt(i, j) instanceof Double) {
                cell.setCellValue(Double.parseDouble(tblDanhSachPhong.getValueAt(i, j).toString()));
              } else {
                cell.setCellValue(tblDanhSachPhong.getValueAt(i, j).toString());
              }
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
        } catch (NumberFormatException | HeadlessException e) {
          e.printStackTrace();
        }
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
  }

  public void importExcel() {
    File excelFile;
    FileInputStream excelFIS = null;
    BufferedInputStream excelBIS = null;
    XSSFWorkbook excelImportToJTable = null;
    JFileChooser excelFileChooser = new JFileChooser();
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

          XSSFCell ma = excelRow.getCell(0);
          XSSFCell ten = excelRow.getCell(1);
          XSSFCell sucChua = excelRow.getCell(2);
          XSSFCell soLuongSofa = excelRow.getCell(3);
          XSSFCell soLuongTV = excelRow.getCell(4);
          XSSFCell TV = excelRow.getCell(5);
          XSSFCell loaiPhong = excelRow.getCell(6);
          XSSFCell chieuRong = excelRow.getCell(7);
          XSSFCell giaPhong = excelRow.getCell(8);
          XSSFCell chieuDai = excelRow.getCell(9);
          XSSFCell ban = excelRow.getCell(10);
          XSSFCell sofa = excelRow.getCell(11);
          modelDanhSachPhong.addRow(new Object[] { ma, ten, sucChua, soLuongSofa, soLuongTV, TV, loaiPhong, chieuRong,
              giaPhong, chieuDai, ban, sofa });

        }
        JOptionPane.showMessageDialog(null, "Nhập dữ liệu thành công!!.....");
        btnImportFile.setText("Lưu dữ liệu (F7)");

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

  private void timKiem() {
    String tenPhong = txtTimKiem.getText();
    if (tenPhong.equals("")) {
      JOptionPane.showMessageDialog(null, "Bạn chưa nhập tên phòng cần tìm", "Thông báo",
          JOptionPane.ERROR_MESSAGE);
      loadData();
      txtTimKiem.requestFocus();
      return;
    } else {
      for (int i = 0; i < modelDanhSachPhong.getRowCount(); i++) {
        if (!modelDanhSachPhong.getValueAt(i, 1).equals(tenPhong)) {
          modelDanhSachPhong.removeRow(i);
          i--;
        }
      }

      txtTimKiem.setText("");
    }
  }

  private boolean validator(String chieuRong, String chieuDai, String tenTV, String tenBan, String tenPhong,
      String tenSofa) {
    for (int i = 0; i <= 14; i++) {
      if (phongService.validator(chieuRong, chieuDai, tenTV, tenBan, tenPhong, tenSofa) == i) {
        switch (i) {
          case 1:
            JOptionPane.showMessageDialog(null, "Chiều rộng không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuRong.requestFocus();
            return false;
          case 2:
            JOptionPane.showMessageDialog(null, "Chiều cao không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuDai.requestFocus();
            return false;
          case 3:
            JOptionPane.showMessageDialog(null, "Tên tivi không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTV.requestFocus();
            return false;
          case 4:
            JOptionPane.showMessageDialog(null, "Tên bàn không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtBan.requestFocus();
            return false;
          case 5:
            JOptionPane.showMessageDialog(null, "Tên phòng không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTenPhong.requestFocus();
            return false;
          case 6:
            JOptionPane.showMessageDialog(null, "Tên sofa không được để trống", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTenSoFa.requestFocus();
            return false;
          case 7:
            JOptionPane.showMessageDialog(null, "Chiều rộng phải lớn hơn 0", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuRong.requestFocus();
            return false;
          case 8:
            JOptionPane.showMessageDialog(null, "Chiều cao phải lớn hơn 0", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuDai.requestFocus();
            return false;
          case 9:
            JOptionPane.showMessageDialog(null, "Chiều rộng phải lớn hơn 0", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuRong.requestFocus();
            return false;
          case 10:
            JOptionPane.showMessageDialog(null, "Chiều cao phải lớn hơn 0", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtChieuDai.requestFocus();
            return false;
          case 11:
            JOptionPane.showMessageDialog(null, "Tên tivi không chứa kí tự đặc biệt", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTV.requestFocus();
            return false;
          case 12:
            JOptionPane.showMessageDialog(null, "Tên bàn không chứa kí tự đặc biệt", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtBan.requestFocus();
            return false;
          case 13:
            JOptionPane.showMessageDialog(null, "Tên phòng không chứa kí tự đặc biệt", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTenPhong.requestFocus();
            return false;
          case 14:
            JOptionPane.showMessageDialog(null, "Tên sofa không chứa kí tự đặc biệt", "Thông báo",
                JOptionPane.ERROR_MESSAGE);
            txtTenSoFa.requestFocus();
            return false;
          case 0:
            return true;
        }
      }
    }
    return false;
  }

  @Override
  public void mouseClicked(MouseEvent arg0) {
    Object o = arg0.getComponent();
    if (o.equals(tblDanhSachPhong)) {
      btnThem.setEnabled(false);
      int row = tblDanhSachPhong.getSelectedRow();
      maPhong = tblDanhSachPhong.getValueAt(tblDanhSachPhong.getSelectedRow(), 0).toString();
      txtTenPhong.setText(tblDanhSachPhong.getValueAt(row, 1).toString());
      cmbSucChua.setSelectedItem(tblDanhSachPhong.getValueAt(row, 2).toString());
      cmbSLSofa.setSelectedItem(tblDanhSachPhong.getValueAt(row, 3).toString());
      cmbSLLoa.setSelectedItem(tblDanhSachPhong.getValueAt(row, 4).toString());
      txtTV.setText(tblDanhSachPhong.getValueAt(row, 5).toString());
      cmbLoaiPhong.setSelectedItem(tblDanhSachPhong.getValueAt(row, 6).toString());
      txtChieuRong.setText(tblDanhSachPhong.getValueAt(row, 7).toString().split(" ")[0]);
      txtChieuDai.setText(tblDanhSachPhong.getValueAt(row, 9).toString().split(" ")[0]);
      txtBan.setText(tblDanhSachPhong.getValueAt(row, 10).toString());
      txtTenSoFa.setText(tblDanhSachPhong.getValueAt(row, 11).toString());

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

  void themPhong() {
    String chieuRong = txtChieuRong.getText();
    String chieuDai = txtChieuDai.getText();
    String tv = txtTV.getText();
    String ban = txtBan.getText();
    String tenPhong = txtTenPhong.getText();
    String tenSofa = txtTenSoFa.getText();
    String sucChua = cmbSucChua.getSelectedItem().toString();
    String loaiPhong = cmbLoaiPhong.getSelectedItem().toString();
    LoaiPhongEnum loaiPhongEnum = loaiPhong.equals("VIP") ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG;
    String soLuongLoa = cmbSLLoa.getSelectedItem().toString();
    String soLuongSofa = cmbSLSofa.getSelectedItem().toString();
    String ma = gen.tuTaoMaPhong(loaiPhong);
    String giaPhong = loaiPhong.equals("VIP") ? "200000" : "500000";
    String[] row = { ma, tenPhong, sucChua, soLuongSofa, soLuongLoa, tv, loaiPhong, chieuRong, giaPhong, chieuDai, ban,
        tenSofa };
    if (validator(chieuRong, chieuDai, tv, ban, tenPhong, tenSofa)) {
      phong = new Phong(ma, tenPhong, Double.parseDouble(giaPhong), Integer.parseInt(sucChua),
          Double.parseDouble(chieuRong),
          Double.parseDouble(chieuDai), tv, ban, tenSofa, Integer.parseInt(soLuongSofa), Integer.parseInt(soLuongLoa),
          TrangThaiPhongEnum.TRONG, loaiPhongEnum);
      if (phongService.themPhong(phong)) {
        JOptionPane.showMessageDialog(null, "Thêm phòng thành công");
        modelDanhSachPhong.addRow(row);
        xoaTrang();
      } else
        JOptionPane.showMessageDialog(null, "Thêm thất bại");
    }

  }

  private void suaPhong() {
    int row = tblDanhSachPhong.getSelectedRow();
    if (row == -1) {
      JOptionPane.showMessageDialog(null, "Chưa chọn phòng để cập nhật");
      return;
    }
    String chieuRong = txtChieuRong.getText();
    String chieuDai = txtChieuDai.getText();
    String tv = txtTV.getText();
    String ban = txtBan.getText();
    String tenPhong = txtTenPhong.getText();
    String tenSofa = txtTenSoFa.getText();
    int sucChua = Integer.parseInt(cmbSucChua.getSelectedItem().toString());
    String loaiPhong = cmbLoaiPhong.getSelectedItem().toString();
    int soLuongLoa = Integer.parseInt(cmbSLLoa.getSelectedItem().toString());
    int soLuongSofa = Integer.parseInt(cmbSLSofa.getSelectedItem().toString());
    double giaPhong = loaiPhong.startsWith("V") ? 500000 : 200000;
    LoaiPhongEnum loaiPhongEnum = loaiPhong.startsWith("V") ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG;
    if (validator(chieuRong, chieuDai, tv, ban, tenPhong, tenSofa)) {
      phong = new Phong(maPhong, tenPhong, giaPhong, sucChua, Double.parseDouble(chieuRong),
          Double.parseDouble(chieuDai), tv, ban, tenSofa, soLuongSofa,
          soLuongLoa,
          TrangThaiPhongEnum.HOAT_DONG, loaiPhongEnum);
      boolean rs = phongService.suaPhong(phong);
      if (rs) {
        JOptionPane.showMessageDialog(null, "Cập nhật thành công");
        btnSua.setText("Sửa (F2)");
        xoaTrang();
        flagSua = false;
        loadData();
      } else {
        JOptionPane.showMessageDialog(null, "Cập nhật thất bại");

      }
    }
  }

  void xoaPhong() {
    int row = tblDanhSachPhong.getSelectedRow();
    if (row == -1) {
      JOptionPane.showMessageDialog(null, "Chưa chọn phòng để xóa");
      return;
    }
    if (phongService.xoaPhong(maPhong)) {
      modelDanhSachPhong.removeRow(row);
      JOptionPane.showMessageDialog(null, "xóa thành công");
    } else
      JOptionPane.showMessageDialog(null, "Xóa không thành công");

  }

  void xoaTrang() {
    maPhong = "";
    txtTenPhong.setText("");
    txtChieuRong.setText("");
    txtChieuDai.setText("");
    txtTV.setText("");
    txtBan.setText("");
    txtTenSoFa.setText("");
    cmbSucChua.setSelectedIndex(0);
    cmbLoaiPhong.setSelectedIndex(0);
    cmbSLLoa.setSelectedIndex(0);
    cmbSLSofa.setSelectedIndex(0);
    btnThem.setEnabled(true);
  }

  void loadData() {
    modelDanhSachPhong.setRowCount(0);
    txtTimKiem.setText("");
    List<Phong> listPhong = phongService.dsPhong();
    try {
      for (Phong phong : listPhong) {
        String loaiPhong = "";
        for (LoaiPhongEnum t : LoaiPhongEnum.values()) {
          if (phong.getLoaiPhong().equals(t)) {
            loaiPhong = t.getLoaiPhong();
          }
        }

        String[] row = {
            phong.getMaPhong().trim(),
            phong.getTenPhong().trim(),
            phong.getSucChua() + "",
            phong.getSoLuongSofa() + "",
            phong.getSoLuongLoa() + "",
            phong.getTenTV().trim(),
            loaiPhong,
            String.valueOf(phong.getChieuRong()).split("\\.")[0] + " m",
            phong.getgiaPhong() + "",
            String.valueOf(phong.getchieuDai()).split("\\.")[0] + " m",
            phong.getTenBan().trim(),
            phong.getTenSofa().trim()
        };
        modelDanhSachPhong.addRow(row);
      }
    } catch (

    Exception e) {
      JOptionPane.showMessageDialog(null, e);
    }

  }

}
