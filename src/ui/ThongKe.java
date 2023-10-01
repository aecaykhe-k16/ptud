package ui;

import static util.Constants.THIRD_COLOR;
import static util.Constants.TITLE;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.HeadlessException;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.swing.BorderFactory;
import javax.swing.ButtonGroup;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.Timer;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.kordamp.ikonli.fontawesome5.FontAwesomeSolid;
import org.kordamp.ikonli.swing.FontIcon;

import com.toedter.calendar.JDateChooser;

import bus.IDangNhapService;
import bus.IPhanCongCaLamService;
import bus.implement.DangNhapImp;
import bus.implement.PhanCongCaLamImp;
import bus.implement.ThongKeDoanhThuImp;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.HoaDon;
import entities.TaiKhoan;
import util.ConnectDB;
import util.Constants;
import util.MyButton;
import util.SpecialButton;

public class ThongKe extends JFrame implements ActionListener {
  private JPanel pnlMenu, pnlTop, pnInfo, pnlMainThongKe;
  private JLabel lblIconLogo, lblTitle, lblChonNgay, lblChonThang, lblThongKeTheo, lblDoanhThu, lblValueDoanhThu,
      lblChonNam, lblTongHoaDon, lblDanhSachCaLam, lblHoaDon;
  private JButton btnThongKe, btnXuatFile, btnIconUser, btnIconLogout, btnTongQuan, btnChiTiet,
      btnNextPage, btnBackPage, btnThongke;
  private JComboBox<String> comboBoxThongKeTheoDT, comboBoxThongKeTheoKH, comboBoxThongKeTheoDV;
  private JComboBox<Integer> comboThang, comboNam;
  private JTable tableThongKe;
  private DefaultTableModel tableModelThongKe;

  private JPanel pnlMainUI, pnlTongQuan, pnlChiTiet;
  private JFreeChart barChart, barCharts;
  private DefaultCategoryDataset dataset;
  private ChartPanel chartPanel, chartPanells;

  private JRadioButton rdBtnThongKeKH, rdBtnThongKeDV, rdBtnThongkeDoanhThu, rdBieuDoDuong, rdbieuDoCot;

  private JDateChooser txtNgay;

  private Locale localeVN = new Locale("vi", "VN");
  private NumberFormat vn = NumberFormat.getInstance(localeVN);

  // slider
  private JButton btnNhanVien, btnPhong, btnKhachHang, btnPhanCong, btnTroGiup,
      btnQuanLyDatPhong, btnDichVu, btnHoaDon;
  private JLabel lblNhanVien, lblPhong, lblKhachHang, lblThongke, lblPhanCong,
      lblQuanLyDatPhong, lblDichVu;
  private JLayeredPane layeredPane;

  private Cursor handCursor;
  private ThongKeDoanhThuImp doanhThuImp = new ThongKeDoanhThuImp();
  private IDangNhapService dangNhap = new DangNhapImp();

  private TaiKhoan tk;

  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private IPhanCongCaLamService caLamService = new PhanCongCaLamImp();

  public ThongKe(TaiKhoan taiKhoan) throws MalformedURLException {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    tk = taiKhoan;

    setTitle(TITLE);
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
    layeredPane.add(pnlMainUI, 1);
    giaodien();
  }

  private void giaodien() {
    PnlTop();
    PnlMenu();
    PnlThongKe();
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
    btnIconUser.setForeground(Color.WHITE);
    btnIconUser.setIcon(FontIcon.of(FontAwesomeSolid.USER, 30, Color.WHITE));
    btnIconUser.setBorderPainted(false);
    btnIconUser.setFocusPainted(false);

    btnIconLogout = new SpecialButton(0, Color.decode(Constants.TITLE_COLOR), Color.decode(Constants.TITLE_COLOR));
    btnIconLogout.setText(Constants.DANG_XUAT);
    btnIconLogout.setBounds(30, 50, 200, 50);
    btnIconLogout.setFont(new Font(Constants.MAIN_FONT, Font.BOLD, 16));
    btnIconLogout.setBorder(null);
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

  void PnlThongKe() {

    pnlMainThongKe = new JPanel();
    pnlMainThongKe.setBounds(0, 150, 1800, 650);
    pnlMainThongKe.setLayout(null);

    ButtonGroup buttonGroup = new ButtonGroup();

    rdBtnThongkeDoanhThu = new JRadioButton("Thống Kê Doanh Thu");
    rdBtnThongkeDoanhThu.setBounds(150, 10, 230, 30);
    rdBtnThongkeDoanhThu.setFont(new Font("Arial", Font.BOLD, 18));
    pnlMainThongKe.add(rdBtnThongkeDoanhThu);

    rdBtnThongKeKH = new JRadioButton("Thống kê Khách Hàng");
    rdBtnThongKeKH.setBounds(380, 10, 230, 30);
    rdBtnThongKeKH.setFont(new Font("Arial", Font.BOLD, 18));
    pnlMainThongKe.add(rdBtnThongKeKH);

    rdBtnThongKeDV = new JRadioButton("Thống Kê Dịch Vụ");
    rdBtnThongKeDV.setBounds(610, 10, 230, 30);
    rdBtnThongKeDV.setFont(new Font("Arial", Font.BOLD, 18));
    pnlMainThongKe.add(rdBtnThongKeDV);

    buttonGroup.add(rdBtnThongkeDoanhThu);
    buttonGroup.add(rdBtnThongKeDV);
    buttonGroup.add(rdBtnThongKeKH);

    lblThongKeTheo = new JLabel("Thống Kê Theo:");
    lblThongKeTheo.setBounds(170, 50, 200, 30);
    lblThongKeTheo.setFont(new Font("Arial", Font.BOLD, 18));

    String[] arrThongKeTheo = { "--------Chọn option-----", "thống kê theo ngày", "thống kê theo tháng",
        "thống kê theo năm" };
    comboBoxThongKeTheoDT = new JComboBox<String>(arrThongKeTheo);
    comboBoxThongKeTheoDT.setBounds(320, 50, 220, 30);
    comboBoxThongKeTheoDT.setFont(new Font("Arial", Font.PLAIN, 18));
    comboBoxThongKeTheoDT.setCursor(new Cursor(Cursor.HAND_CURSOR));

    lblChonNgay = new JLabel("Chọn ngày: ");
    lblChonNgay.setBounds(650, 50, 150, 30);
    lblChonNgay.setFont(new Font("Arial", Font.BOLD, 20));

    txtNgay = new JDateChooser();
    txtNgay.setFont(new Font("Arial", Font.ITALIC, 18));
    txtNgay.setBounds(780, 50, 200, 30);
    txtNgay.setCursor(new Cursor(Cursor.HAND_CURSOR));
    txtNgay.setDateFormatString("dd-MM-yyyy");

    Calendar calendar = Calendar.getInstance();

    txtNgay.setDate(calendar.getTime());

    lblChonThang = new JLabel("Chọn tháng: ");
    lblChonThang.setBounds(650, 50, 150, 30);
    lblChonThang.setFont(new Font("Arial", Font.BOLD, 20));

    comboThang = new JComboBox<Integer>();
    for (int i = 1; i < 13; i++) {
      comboThang.addItem(i);
    }

    comboThang.setBounds(800, 50, 200, 30);
    comboThang.setFont(new Font("Arial", Font.BOLD, 18));
    int mm = calendar.get(Calendar.MONTH) + 1;
    comboThang.setSelectedItem(mm);

    lblChonNam = new JLabel("Chọn năm: ");
    lblChonNam.setBounds(1100, 50, 150, 30);
    lblChonNam.setFont(new Font("Arial", Font.BOLD, 20));

    comboNam = new JComboBox<Integer>();
    for (int i = 2000; i < 2050; i++) {
      comboNam.addItem(i);
    }
    comboNam.setBounds(1220, 50, 200, 30);
    comboNam.setFont(new Font("Arial", Font.BOLD, 18));
    int yyyy = calendar.get(Calendar.YEAR);
    comboNam.setSelectedItem(yyyy);
    /**
     * thông kê khách hàng
     */
    comboBoxThongKeTheoKH = new JComboBox<String>();
    comboBoxThongKeTheoKH.addItem("--------Chọn option-----");
    comboBoxThongKeTheoKH.addItem("số lượng khách hàng");
    comboBoxThongKeTheoKH.setFont(new Font("Arial", Font.PLAIN, 18));
    comboBoxThongKeTheoKH.setCursor(new Cursor(Cursor.HAND_CURSOR));
    comboBoxThongKeTheoKH.setBounds(320, 50, 220, 30);
    /**
     * thống kê dịch vụ
     */
    comboBoxThongKeTheoDV = new JComboBox<String>();
    comboBoxThongKeTheoDV.addItem("--------Chọn option-----");
    comboBoxThongKeTheoDV.addItem("thống kê dịch vụ khác");
    comboBoxThongKeTheoDV.addItem("thống kê dịch vụ phòng");
    comboBoxThongKeTheoDV.setFont(new Font("Arial", Font.PLAIN, 18));
    comboBoxThongKeTheoDV.setCursor(new Cursor(Cursor.HAND_CURSOR));
    comboBoxThongKeTheoDV.setBounds(320, 50, 220, 30);

    JPanel pnLine = new JPanel();
    pnLine.setBackground(Color.black);
    pnLine.setForeground(Color.black);
    pnLine.setBounds(150, 90, 1280, 3);

    btnThongKe = new MyButton(10, Color.decode("#009EFF"), Color.decode(THIRD_COLOR));
    btnThongKe.setText("Thống kê");
    btnThongKe.setBounds(150, 120, 120, 30);
    btnThongKe.setFont(new Font("Tahoma", Font.BOLD, 18));
    btnThongKe.setBorderPainted(false);
    btnThongKe.setFocusPainted(false);
    btnThongKe.setCursor(new Cursor(Cursor.HAND_CURSOR));

    btnXuatFile = new MyButton(10, Color.decode("#379237"), Color.decode(THIRD_COLOR));
    btnXuatFile.setText("Xuất excel");
    btnXuatFile.setFont(new Font("Tahoma", Font.BOLD, 18));
    btnXuatFile.setBounds(280, 120, 120, 30);
    btnXuatFile.setBorderPainted(false);
    btnXuatFile.setFocusPainted(false);
    btnXuatFile.setBorder(BorderFactory.createBevelBorder(0));
    btnXuatFile.setCursor(new Cursor(Cursor.HAND_CURSOR));

    lblTongHoaDon = new JLabel();
    lblTongHoaDon.setText("TỔNG HÓA ĐƠN: 0");
    lblTongHoaDon.setForeground(Color.red);
    lblTongHoaDon.setFont(new Font("Arial", Font.BOLD, 25));
    lblTongHoaDon.setBounds(650, 120, 350, 30);

    lblValueDoanhThu = new JLabel("0 VND");
    lblValueDoanhThu.setForeground(Color.red);
    lblValueDoanhThu.setBounds(1000, 120, 300, 30);
    lblValueDoanhThu.setFont(new Font("Arial", Font.BOLD, 25));
    lblDoanhThu = new JLabel("Doanh thu");
    lblDoanhThu.setBounds(1000, 140, 100, 30);
    lblDoanhThu.setFont(new Font("Arial", Font.ITALIC, 15));
    lblDoanhThu.setForeground(Color.decode("#3665CE"));

    lblTongHoaDon.setVisible(false);
    lblDoanhThu.setVisible(false);
    lblValueDoanhThu.setVisible(false);

    JPanel pnLine2 = new JPanel();
    pnLine2.setBackground(Color.black);
    pnLine2.setForeground(Color.black);
    pnLine2.setBounds(150, 180, 1280, 3);

    btnTongQuan = new MyButton(10, Color.decode("#65647C"), Color.decode(THIRD_COLOR));
    btnTongQuan.setText("Tổng quan");
    btnTongQuan.setBorderPainted(false);
    btnTongQuan.setFocusPainted(false);
    btnTongQuan.setBounds(150, 185, 120, 30);

    btnChiTiet = new MyButton(10, Color.decode("#65647C"), Color.decode(THIRD_COLOR));
    btnChiTiet.setText("Chi tiết");
    btnChiTiet.setBorderPainted(false);
    btnChiTiet.setFocusPainted(false);
    btnChiTiet.setBounds(280, 185, 120, 30);

    btnNextPage = new MyButton(50, new Color(255, 255, 255), new Color(255, 255, 255));
    btnNextPage.setBounds(1250, 20, 30, 25);
    btnNextPage.setBorderPainted(false);
    btnNextPage.setFocusPainted(false);
    btnNextPage.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_RIGHT, 15));

    btnBackPage = new MyButton(50, new Color(255, 255, 255), new Color(255, 255, 255));
    btnBackPage.setBounds(1210, 20, 30, 25);
    btnBackPage.setBorderPainted(false);
    btnBackPage.setFocusPainted(false);
    btnBackPage.setIcon(FontIcon.of(FontAwesomeSolid.CHEVRON_LEFT, 15));

    pnlTongQuan = new JPanel();
    pnlTongQuan.setBounds(150, 200, 1280, 450);
    pnlTongQuan.setLayout(null);

    pnlChiTiet = new JPanel();
    pnlChiTiet.setBounds(150, 200, 1280, 450);
    pnlChiTiet.setLayout(null);

    pnlChiTiet.setVisible(false);

    /**
     * table phần chi tiết
     */
    String[] header = { "Mã hóa đơn", "Ngày lập hóa đơn", "Khách hàng", "Doanh thu (VND)" };

    tableModelThongKe = new DefaultTableModel(header, 0);

    tableThongKe = new JTable(tableModelThongKe);
    tableThongKe.setDefaultEditor(Object.class, null);

    tableThongKe.setAutoCreateRowSorter(true);

    JScrollPane scrollPane = new JScrollPane(tableThongKe);
    scrollPane.setBounds(0, 40, 1280, 300);

    pnlChiTiet.add(scrollPane);

    /**
     * Biểu đố thống kê
     */
    dataset = new DefaultCategoryDataset();

    barChart = ChartFactory.createBarChart(
        "BIỂU ĐỒ DOANH THU THEO NGÀY",
        "", "",
        dataset, PlotOrientation.VERTICAL, false, true, false);

    barCharts = ChartFactory.createAreaChart("BIỂU ĐỒ DOANH THU", "", "", dataset);
    CategoryPlot c = barChart.getCategoryPlot();
    c.setRangeGridlinePaint(Color.black);

    chartPanells = new ChartPanel(barCharts);
    chartPanells.setBounds(0, 50, 1280, 350);

    chartPanel = new ChartPanel(barChart);
    chartPanel.setBounds(0, 50, 1280, 350);

    ButtonGroup buttonGroup2 = new ButtonGroup();

    rdbieuDoCot = new JRadioButton("Biểu đồ cột");
    rdBieuDoDuong = new JRadioButton("Biểu đồ núi");
    rdBieuDoDuong.addActionListener(this);
    rdbieuDoCot.addActionListener(this);

    buttonGroup2.add(rdbieuDoCot);
    buttonGroup2.add(rdBieuDoDuong);

    rdbieuDoCot.setBounds(500, 400, 100, 20);
    rdBieuDoDuong.setBounds(650, 400, 100, 20);

    /**
     * add component
     */
    pnlMainThongKe.add(comboBoxThongKeTheoDV);
    pnlMainThongKe.add(comboBoxThongKeTheoKH);
    pnlMainThongKe.add(lblTongHoaDon);
    pnlMainThongKe.add(lblChonNam);
    pnlMainThongKe.add(comboNam);
    pnlMainThongKe.add(comboThang);
    pnlMainThongKe.add(txtNgay);
    pnlMainThongKe.add(lblChonThang);
    pnlMainThongKe.add(lblChonNgay);
    pnlMainThongKe.add(lblThongKeTheo);
    pnlMainThongKe.add(comboBoxThongKeTheoDT);
    pnlMainThongKe.add(btnThongKe);
    pnlMainThongKe.add(btnXuatFile);
    pnlMainThongKe.add(lblValueDoanhThu);
    pnlMainThongKe.add(lblDoanhThu);
    pnlMainThongKe.add(pnLine2);
    pnlMainThongKe.add(pnLine);

    pnlMainThongKe.add(btnTongQuan);
    pnlMainThongKe.add(btnChiTiet);
    pnlMainThongKe.add(pnlTongQuan);
    pnlMainThongKe.add(pnlChiTiet);

    pnlTongQuan.add(chartPanel);
    pnlTongQuan.add(chartPanells);
    pnlTongQuan.add(rdbieuDoCot);
    pnlTongQuan.add(rdBieuDoDuong);
    pnlTongQuan.add(btnBackPage);
    pnlTongQuan.add(btnNextPage);

    pnlMainUI.add(pnlMainThongKe);

    chartPanells.setVisible(false);
    /**
     * add event
     */
    btnThongKe.addActionListener(this);
    btnXuatFile.addActionListener(this);
    rdBtnThongkeDoanhThu.addActionListener(this);
    rdBtnThongKeDV.addActionListener(this);
    rdBtnThongKeKH.addActionListener(this);
    btnTongQuan.addActionListener(this);
    btnChiTiet.addActionListener(this);
    btnNextPage.addActionListener(this);
    btnBackPage.addActionListener(this);

    txtNgay.setVisible(false);
    comboThang.setVisible(false);
    comboNam.setVisible(false);
    lblChonNgay.setVisible(false);
    lblChonThang.setVisible(false);
    lblChonNam.setVisible(false);
    comboBoxThongKeTheoDT.setVisible(false);
    comboBoxThongKeTheoDV.setVisible(false);
    comboBoxThongKeTheoKH.setVisible(false);
    lblThongKeTheo.setVisible(false);

    if (rdBtnThongkeDoanhThu.isSelected() == true) {
      lblThongKeTheo.setVisible(true);
      comboBoxThongKeTheoDT.setVisible(true);
    }

    rdBtnThongkeDoanhThu.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        if (rdBtnThongkeDoanhThu.isSelected()) {
          barChart.setTitle("BIỂU ĐỒ DOANH THU THEO NGÀY");
          comboBoxThongKeTheoDT.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
              int index = comboBoxThongKeTheoDT.getSelectedIndex();
              if (index == 1) {
                barChart.setTitle("BIỂU ĐỒ DOANH THU THE0 NGÀY");
                txtNgay.setVisible(true);
                comboThang.setVisible(false);
                comboNam.setVisible(false);
                lblChonNgay.setVisible(true);
                lblChonThang.setVisible(false);
                lblChonNam.setVisible(false);
              } else if (index == 2) {
                barChart.setTitle("BIỂU ĐỒ DOANH THU THE0 THÁNG");
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(true);
                comboNam.setVisible(true);
                lblChonThang.setVisible(true);
                lblChonNam.setVisible(true);
                lblChonNam.setBounds(1100, 50, 150, 30);
                comboNam.setBounds(1220, 50, 200, 30);
              } else if (index == 3) {
                barChart.setTitle("BIỂU ĐỒ DOANH THU THE0 NĂM");
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(false);
                lblChonThang.setVisible(false);
                comboNam.setVisible(true);
                lblChonNam.setVisible(true);
                lblChonNam.setBounds(650, 50, 150, 30);
                comboNam.setBounds(780, 50, 200, 30);
              } else {
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(false);
                lblChonThang.setVisible(false);
                comboNam.setVisible(false);
                lblChonNam.setVisible(false);
              }
            }
          });
        }
      }
    });

    rdBtnThongKeKH.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        if (rdBtnThongKeKH.isSelected()) {
          barChart.setTitle("BIỂU ĐỒ DOANH THU KHÁCH HÀNG");
          comboBoxThongKeTheoKH.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
              if (comboBoxThongKeTheoKH.getSelectedIndex() == 1) {
                barChart.setTitle("BIỂU ĐỒ SỐ LƯỢNG KHÁCH HÀNG TỪNG THÁNG");
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(true);
                comboNam.setVisible(true);
                lblChonThang.setVisible(true);
                lblChonNam.setVisible(true);
                lblChonNam.setBounds(1100, 50, 150, 30);
                comboNam.setBounds(1220, 50, 200, 30);
              } else {
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(false);
                comboNam.setVisible(false);
                lblChonThang.setVisible(false);
                lblChonNam.setVisible(false);
              }
            }
          });
        }
      }
    });

    rdBtnThongKeDV.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        if (rdBtnThongKeDV.isSelected()) {
          barChart.setTitle("BIỂU ĐỒ MỨC THƯỜNG DÙNG CỦA TỪNG DỊCH VỤ");
          comboBoxThongKeTheoDV.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
              if (comboBoxThongKeTheoDV.getSelectedIndex() == 1) {
                barChart.setTitle("BIỂU ĐỒ MỨC THƯỜNG DÙNG CỦA TỪNG DỊCH VỤ");
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(true);
                comboNam.setVisible(true);
                lblChonThang.setVisible(true);
                lblChonNam.setVisible(true);
                lblChonNam.setBounds(1100, 50, 150, 30);
                comboNam.setBounds(1220, 50, 200, 30);
              } else if (comboBoxThongKeTheoDV.getSelectedIndex() == 2) {
                barChart.setTitle("BIỂU ĐỒ MỨC THƯỜNG DÙNG CỦA TỪNG PHÒNG");
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(true);
                comboNam.setVisible(true);
                lblChonThang.setVisible(true);
                lblChonNam.setVisible(true);
                lblChonNam.setBounds(1100, 50, 150, 30);
                comboNam.setBounds(1220, 50, 200, 30);
              } else {
                txtNgay.setVisible(false);
                lblChonNgay.setVisible(false);
                comboThang.setVisible(false);
                comboNam.setVisible(false);
                lblChonThang.setVisible(false);
                lblChonNam.setVisible(false);
              }
            }
          });
        }
      }
    });

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
      btnThongke.setIcon(FontIcon.of(FontAwesomeSolid.CHART_BAR, 30, Color.decode("#7743DB")));
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

  @Override
  public void actionPerformed(ActionEvent e) {
    String oldText = lblDanhSachCaLam.getText();
    String newText = oldText.substring(1) + oldText.substring(0, 1);
    lblDanhSachCaLam.setText(newText);
    Object o = e.getSource();
    Calendar cal = Calendar.getInstance();
    try {
      if (o.equals(btnPhong)) {
        new QuanLyPhong(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnNhanVien)) {
        new QLNhanVien(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnThongke)) {
        new ThongKe(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnPhanCong)) {
        new PhanCongCaLam(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnIconUser)) {
        new ThongTinNguoiDung(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnIconLogout)) {
        int tb = JOptionPane.showConfirmDialog(this, "Bạn có chắc chắn muốn đăng xuất không", "Cảnh báo",
            JOptionPane.YES_NO_OPTION);
        if (tb == JOptionPane.YES_OPTION) {
          new DangNhap().setVisible(true);

          this.dispose();
        }
      } else if (o.equals(btnHoaDon)) {
        new HoaDonUi(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnDichVu)) {
        new DichVuUI(tk).setVisible(true);
        this.dispose();
      } else if (o.equals(btnQuanLyDatPhong)) {
        new QuanLyDatPhong(tk).setVisible(true);
        this.dispose();
      } else if (e.getSource() == btnTroGiup) {
        Desktop.getDesktop().browse(new URL("https://ptud.netlify.app/").toURI());
      }
    } catch (Exception e1) {
      e1.printStackTrace();
    }

    if (e.getSource() == btnThongKe) {
      if (rdBtnThongkeDoanhThu.isSelected() == false && rdBtnThongKeKH.isSelected() == false
          && rdBtnThongKeDV.isSelected() == false) {
        JOptionPane.showMessageDialog(null, "Vui lòng chọn chức năng thống kê");
      } else {
        if (rdBtnThongkeDoanhThu.isSelected()) {
          lblTongHoaDon.setVisible(true);
          lblDoanhThu.setVisible(true);
          lblValueDoanhThu.setVisible(true);
          if (comboBoxThongKeTheoDT.getSelectedIndex() == 1) {
            if (txtNgay.getDate() == null) {
              JOptionPane.showMessageDialog(null, "Ngày không hợp lệ");
            } else {
              cal.setTime(txtNgay.getDate());

              thongKeDTNgay(cal.getTime());

            }
          } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 2) {
            int moth = Integer.parseInt(comboThang.getSelectedItem().toString());
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());

            thongKeDoanhThuThang(moth, year);
          } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 3) {
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());
            if (year > cal.get(Calendar.YEAR)) {
              JOptionPane.showMessageDialog(null, "Năm thống kê phải bé hơn bằng năm hiện tại");
            } else {
              thongKeDTNam(year);
            }
          }
        } else if (rdBtnThongKeKH.isSelected()) {
          lblTongHoaDon.setVisible(false);
          lblDoanhThu.setVisible(false);
          lblValueDoanhThu.setVisible(false);
          if (comboBoxThongKeTheoKH.getSelectedIndex() == 1) {
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());
            int month = Integer.parseInt(comboThang.getSelectedItem().toString());

            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(month, year);

            barChart.setTitle("BIỂU ĐỒ SỐ LƯỢNG KHÁCH HÀNG THÁNG " + month);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLKH(dsHD);
          }
        } else if (rdBtnThongKeDV.isSelected()) {
          lblTongHoaDon.setVisible(false);
          lblDoanhThu.setVisible(false);
          lblValueDoanhThu.setVisible(false);
          if (comboBoxThongKeTheoDV.getSelectedIndex() == 1) {
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());
            int month = Integer.parseInt(comboThang.getSelectedItem().toString());

            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(month, year);

            barChart.setTitle("BIỂU ĐỒ SỐ LẦN SỬ DỤNG TỪNG DỊCH VỤ THÁNG " + month);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDV(dsHD);
          } else if (comboBoxThongKeTheoDV.getSelectedIndex() == 2) {
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());
            int month = Integer.parseInt(comboThang.getSelectedItem().toString());

            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(month, year);

            barChart.setTitle("BIỂU ĐỒ THỜI GIAN(giờ) SỬ DỤNG TỪNG PHÒNG TRONG THÁNG " + month);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDvPHONG(dsHD);
          }
        }
      }
    }
    /**
     * back page
     */
    if (e.getSource() == btnBackPage) {
      if (rdBtnThongkeDoanhThu.isSelected()) {
        if (comboBoxThongKeTheoDT.getSelectedIndex() == 1) {
          int days = -1;
          cal.setTime(txtNgay.getDate());
          cal.roll(Calendar.DATE, days);

          thongKeDTNgay(cal.getTime());

          txtNgay.setDate(cal.getTime());
          days--;
        } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 2) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());

          int mm = Integer.parseInt(comboThang.getSelectedItem().toString());
          mm--;

          if (mm > 0 && mm < 12) {
            thongKeDoanhThuThang(mm, year);
          }

          comboThang.setSelectedItem(mm);
        } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 3) {
          int yyyy = Integer.parseInt(comboNam.getSelectedItem().toString());
          yyyy--;
          thongKeDTNam(yyyy);
          comboNam.setSelectedItem(yyyy);
        }
      }
      if (rdBtnThongKeKH.isSelected()) {
        if (comboBoxThongKeTheoKH.getSelectedIndex() == 1) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          ;
          int mm = Integer.parseInt(comboThang.getSelectedItem().toString());
          mm--;

          if (mm > 0) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(mm, year);

            barChart.setTitle("BIỂU ĐỒ SỐ LƯỢNG KHÁCH HÀNG THÁNG " + mm);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLKH(dsHD);
            comboThang.setSelectedItem(mm);
          }
        }
      }
      if (rdBtnThongKeDV.isSelected()) {
        if (comboBoxThongKeTheoDV.getSelectedIndex() == 1) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          int mm = Integer.parseInt(comboThang.getSelectedItem().toString());
          mm--;

          if (mm >= 1) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(mm, year);

            barChart.setTitle("BIỂU ĐỒ MỨC SỬ DỤNG DỊCH VỤ THÁNG " + mm);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDV(dsHD);

            comboThang.setSelectedItem(mm);
          }
        } else if (comboBoxThongKeTheoDV.getSelectedIndex() == 2) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          int mm = Integer.parseInt(comboThang.getSelectedItem().toString());
          mm--;

          if (mm >= 1) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(mm, year);

            barChart.setTitle("BIỂU ĐỒ MỨC SỬ DỤNG DỊCH VỤ PHÒNG THÁNG " + mm);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDvPHONG(dsHD);

            comboThang.setSelectedItem(mm);
          }
        }
      }
    }
    /**
     * next page
     */
    if (e.getSource() == btnNextPage) {
      if (rdBtnThongkeDoanhThu.isSelected()) {
        if (comboBoxThongKeTheoDT.getSelectedIndex() == 1) {
          int days = 1;
          cal.setTime(txtNgay.getDate());
          cal.roll(Calendar.DATE, days);

          thongKeDTNgay(cal.getTime());

          txtNgay.setDate(cal.getTime());
          days++;
        } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 2) {
          int month = Integer.parseInt(comboThang.getSelectedItem().toString());
          month++;

          if (month <= 12 && month >= 1) {
            int year = Integer.parseInt(comboNam.getSelectedItem().toString());

            thongKeDoanhThuThang(month, year);
            comboThang.setSelectedItem(month);
          }
        } else if (comboBoxThongKeTheoDT.getSelectedIndex() == 3) {
          int yyyy = Integer.parseInt(comboNam.getSelectedItem().toString());
          yyyy++;
          Calendar calendar = Calendar.getInstance();
          int year = calendar.get(Calendar.YEAR);
          if (yyyy > year) {
            JOptionPane.showMessageDialog(null, "Năm thống kê phải bé hơn bằng năm hiện tại");
          } else {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoNam(yyyy);

            barChart.setTitle("BIỂU ĐỒ DOANH THU NĂM " + yyyy);

            BieuDoThongKeTheoNam(dsHD);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            comboNam.setSelectedItem(yyyy);
          }
        }
      }
      if (rdBtnThongKeKH.isSelected()) {
        if (comboBoxThongKeTheoKH.getSelectedIndex() == 1) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          int mm = Integer.parseInt(comboThang.getSelectedItem().toString());
          mm++;

          if (mm <= 12 && mm >= 1) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(mm, year);

            barChart.setTitle("BIỂU ĐỒ DOANH THU KHÁCH HÀNG THÁNG " + mm);

            barChart.setTitle("BIỂU ĐỒ SỐ LƯỢNG KHÁCH HÀNG THÁNG " + mm);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLKH(dsHD);
            comboThang.setSelectedItem(mm);
          }
        }
      }
      if (rdBtnThongKeDV.isSelected()) {
        if (comboBoxThongKeTheoDV.getSelectedIndex() == 1) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          int months = Integer.parseInt(comboThang.getSelectedItem().toString());
          months++;

          if (months <= 12) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(months, year);

            barChart.setTitle("BIỂU ĐỒ MỨC SỬ DỤNG DỊCH VỤ THÁNG " + months);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDV(dsHD);

            comboThang.setSelectedItem(months);
          }
        } else if (comboBoxThongKeTheoDV.getSelectedIndex() == 2) {
          int year = Integer.parseInt(comboNam.getSelectedItem().toString());
          int months = Integer.parseInt(comboThang.getSelectedItem().toString());
          months++;

          if (months <= 12) {
            List<HoaDon> dsHD = new ArrayList<>();
            dsHD = doanhThuImp.thongKeTheoThang(months, year);

            barChart.setTitle("BIỂU ĐỒ MỨC SỬ DỤNG DỊCH VỤ PHÒNG THÁNG " + months);
            lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());

            BieuDoThongKeSLDV(dsHD);

            comboThang.setSelectedItem(months);
          }
        }
      }
    }
    if (e.getSource() == btnXuatFile) {
      exportExcelFile();
    }
    if (e.getSource() == rdBtnThongkeDoanhThu) {
      if (rdBtnThongkeDoanhThu.isSelected() == true) {
        lblThongKeTheo.setVisible(true);
        comboBoxThongKeTheoDT.setVisible(true);
        comboBoxThongKeTheoKH.setVisible(false);
        comboBoxThongKeTheoDV.setVisible(false);
      }
    } else if (e.getSource() == rdBtnThongKeKH) {
      if (rdBtnThongKeKH.isEnabled() == true) {
        lblThongKeTheo.setVisible(true);
        comboBoxThongKeTheoKH.setVisible(true);
        comboBoxThongKeTheoDT.setVisible(false);
        comboBoxThongKeTheoDV.setVisible(false);

        txtNgay.setVisible(false);
        comboThang.setVisible(false);
        comboNam.setVisible(false);
        lblChonNgay.setVisible(false);
        lblChonThang.setVisible(false);
        lblChonNam.setVisible(false);
      }
    } else if (e.getSource() == rdBtnThongKeDV) {
      if (rdBtnThongKeDV.isEnabled() == true) {
        lblThongKeTheo.setVisible(true);
        comboBoxThongKeTheoDV.setVisible(true);
        comboBoxThongKeTheoKH.setVisible(false);
        comboBoxThongKeTheoDT.setVisible(false);

        txtNgay.setVisible(false);
        comboThang.setVisible(false);
        comboNam.setVisible(false);
        lblChonNgay.setVisible(false);
        lblChonThang.setVisible(false);
        lblChonNam.setVisible(false);
      }
    } else if (e.getSource() == rdBieuDoDuong) {
      if (rdBieuDoDuong.isSelected()) {
        chartPanel.setVisible(false);
        chartPanells.setVisible(true);
      }
    } else if (e.getSource() == rdbieuDoCot) {
      if (rdbieuDoCot.isSelected()) {
        chartPanel.setVisible(true);
        chartPanells.setVisible(false);
      }
    } else if (e.getSource() == btnTongQuan) {
      pnlTongQuan.setVisible(true);
      pnlChiTiet.setVisible(false);
    } else if (e.getSource() == btnChiTiet) {
      pnlTongQuan.setVisible(false);
      pnlChiTiet.setVisible(true);
    }
  }

  private void thongKeDTNam(int year) {
    List<HoaDon> dsHD = new ArrayList<>();
    dsHD = doanhThuImp.thongKeTheoNam(year);

    barChart.setTitle("BIỂU ĐỒ DOANH THU NĂM " + year);

    BieuDoThongKeTheoNam(dsHD);
    double doanhThu = 0;
    for (HoaDon hoaDon : dsHD) {
      doanhThu += hoaDon.tinhTongTien();
    }

    lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());
    lblValueDoanhThu.setText(vn.format(doanhThu));

  }

  private void thongKeDoanhThuThang(int moth, int year) {
    Calendar cal = Calendar.getInstance();
    if (year > cal.get(Calendar.YEAR)) {
      JOptionPane.showMessageDialog(null, "Năm thống kê phải bé hơn bằng năm hiện tại");
    } else {

      List<HoaDon> dsHD = new ArrayList<>();
      dsHD = doanhThuImp.thongKeTheoThang(moth, year);
      barChart.setTitle("BIỂU ĐỒ DOANH THU THÁNG " + moth);

      BieuDoThongKeTheoThang(dsHD);
      double doanhThu = 0;
      for (HoaDon hoaDon : dsHD) {
        doanhThu += hoaDon.tinhTongTien();
      }

      lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());
      lblValueDoanhThu.setText(vn.format(doanhThu));
    }
  }

  private void thongKeDTNgay(Date time) {
    SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");
    List<HoaDon> dsHD = new ArrayList<>();
    dsHD = doanhThuImp.thongKeTheoNgay(time);

    barChart.setTitle("BIỂU ĐỒ DOANH THU NGÀY " + sf.format(time));

    UpdataTableThongKe(dsHD);
    BieuDoThongKeTheoNgay(dsHD);

    lblTongHoaDon.setText("TỔNG HÓA ĐƠN: " + dsHD.size());
  }

  private void BieuDoThongKeSLDvPHONG(List<HoaDon> dsHD) {
    Map<String, Integer> map = mapSoLuongDV(dsHD, 2);

    String[] header = { "Tên phòng", "Số lượt đặt phòng" };
    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    dataset.clear();
    map.entrySet().forEach(e -> {
      String[] arrTen = e.getKey().split(" ");
      dataset.addValue(e.getValue(), "", arrTen[1].trim());
      String[] row = { e.getKey(), String.valueOf(e.getValue()) };
      tableModelThongKe.addRow(row);
    });
    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();
  }

  private void BieuDoThongKeSLDV(List<HoaDon> dsHD) {
    Map<String, Integer> map = mapSoLuongDV(dsHD, 1);

    String[] header = { "Tên dịch vụ", "Số lượt gọi món" };
    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    dataset.clear();
    map.entrySet().forEach(e -> {
      dataset.addValue(e.getValue(), "", e.getKey().trim());

      String[] row = { e.getKey(), String.valueOf(e.getValue()) };
      tableModelThongKe.addRow(row);
    });

    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();
  }

  private Map<String, Integer> mapSoLuongDV(List<HoaDon> dsHD, int op) {
    Map<String, Integer> map = new HashMap<String, Integer>();

    List<ChiTietDichVu> ctdv = new ArrayList<ChiTietDichVu>();
    List<ChiTietHoaDon> cthd = new ArrayList<ChiTietHoaDon>();

    for (HoaDon h : dsHD) {
      ctdv = h.getCTDV();
      cthd = h.getCTHD();
      if (op == 1) {
        for (ChiTietDichVu dv : ctdv) {
          String word = dv.getDichVu().getTenDichVu();
          if (!map.containsKey(word)) {
            map.put(word, dv.getSoLuong());
          } else {
            map.put(word, map.get(word) + dv.getSoLuong());
          }
        }
      }
      if (op == 2) {
        for (ChiTietHoaDon ch : cthd) {
          String word = ch.getPhong().getTenPhong();
          if (!map.containsKey(word)) {
            map.put(word, (ch.getThoiGianSuDung() / 60));
          } else {
            map.put(word, map.get(word) + ch.getThoiGianSuDung() / 60);
          }
        }
      }
    }
    return map;
  }

  private void BieuDoThongKeSLKH(List<HoaDon> dsHD) {
    Map<String, Integer> mapKH = mapSoLuongKH(dsHD, 2);
    Map<String, Double> mapDT = mapDoanhThu(dsHD, 2);

    DateFormat formatter = new SimpleDateFormat("EEEE", Locale.getDefault());
    Calendar calendar = Calendar.getInstance();
    dataset.clear();

    String[] header = { "Ngày", "Thứ", "Số lượng khách hàng", "Doanh thu ngày đó" };
    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    mapKH.entrySet().forEach(ee -> {
      mapDT.entrySet().forEach(e -> {
        if (ee.getKey().equals(e.getKey())) {
          String[] date = ee.getKey().split("-");
          int year = Integer.parseInt(date[2]);
          int month = Integer.parseInt(date[1]);
          int day = Integer.parseInt(date[0]);
          calendar.set(year, month, day);

          String[] row = { ee.getKey(), formatter.format(calendar.getTime()), String.valueOf(ee.getValue()),
              vn.format(e.getValue()) };
          tableModelThongKe.addRow(row);

          dataset.addValue(ee.getValue(), "Số lượng KH:",
              "Ngày:" + e.getKey().split("-")[0] + ",Số lượng khách:" + ee.getValue());
        }
      });
    });

    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();

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
          for (int j = 0; j < tableThongKe.getColumnCount(); j++) {
            XSSFCell cell = row.createCell(j);
            cell.setCellValue(tableThongKe.getColumnName(j));
          }
          for (int i = 0; i < tableThongKe.getRowCount(); i++) {
            row = spreadsheet.createRow(i + 1);
            for (int j = 0; j < tableThongKe.getColumnCount(); j++) {
              XSSFCell cell = row.createCell(j);

              cell.setCellValue(tableModelThongKe.getValueAt(i, j).toString());

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

  private void BieuDoThongKeTheoNam(List<HoaDon> ds) {

    Map<String, Integer> mapSLHD = mapSoLuongHoaDon(ds, 3);

    Map<String, Double> mapDT = mapDoanhThu(ds, 3);

    Map<String, Integer> mapKH = mapSoLuongKH(ds, 3);

    dataset.clear();

    String[] header = { "Tháng", "Số lượng khách hàng", "Số lượng hóa đơn", "Doanh thu" };
    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    mapDT.entrySet().forEach(ee -> {
      mapSLHD.entrySet().forEach(e -> {
        mapKH.entrySet().forEach(eee -> {
          if (ee.getKey().equals(e.getKey()) && ee.getKey().equals(eee.getKey())) {
            dataset.addValue(ee.getValue(), "Doanh thu", "Tháng " + e.getKey() + ",Số HĐ:" + e.getValue());
            String[] row = { ee.getKey(), String.valueOf(eee.getValue()), String.valueOf(e.getValue()),
                vn.format(ee.getValue()) };
            tableModelThongKe.addRow(row);
          }
        });
      });
    });

    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();

  }

  private void BieuDoThongKeTheoThang(List<HoaDon> ds) {

    dataset.clear();

    Map<String, Integer> mapSLHD = mapSoLuongHoaDon(ds, 2);

    Map<String, Double> mapDT = mapDoanhThu(ds, 2);

    Map<String, Integer> mapKH = mapSoLuongKH(ds, 2);

    String[] header = { "Ngày lập hóa đơn", "Số lượng khách hàng", "Số lượng hóa đơn", "Doanh thu" };
    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    mapDT.entrySet().forEach(ee -> {
      mapSLHD.entrySet().forEach(e -> {
        mapKH.entrySet().forEach(eee -> {
          if (ee.getKey().equals(e.getKey()) && ee.getKey().equals(eee.getKey())) {
            dataset.addValue(ee.getValue(), "Doanh thu", "Ngày " + e.getKey() + ",Số HĐ:" + e.getValue());
            String[] row = { ee.getKey(), String.valueOf(eee.getValue()), String.valueOf(e.getValue()),
                vn.format(ee.getValue()) };
            tableModelThongKe.addRow(row);
          }
        });
      });
    });

    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();
  }

  private void BieuDoThongKeTheoNgay(List<HoaDon> ds) {
    Map<String, Double> map = mapDoanhThu(ds, 1);

    dataset.clear();

    map.entrySet().forEach(e -> {
      dataset.addValue(e.getValue(), "Doanh thu", "Ngày " + e.getKey());
    });
  }

  private Map<String, Integer> mapSoLuongKH(List<HoaDon> ds, int op) {
    int i = 1;
    Map<String, Integer> mapKH = new TreeMap<String, Integer>();
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");

    for (HoaDon h : ds) {
      String word = "";
      if (op == 2) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = sf.format(calendar.getTime());
      }
      if (op == 3) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = String.valueOf(calendar.get(Calendar.MONTH) + 1);
      }
      if (!mapKH.containsKey(word)) {
        mapKH.put(word, i);
      } else {
        mapKH.put(word, mapKH.get(word) + i);
      }
    }
    return mapKH;
  }

  private Map<String, Double> mapDoanhThu(List<HoaDon> ds, int op) {
    Map<String, Double> map = new TreeMap<>();
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");

    for (HoaDon h : ds) {
      String word = "";
      if (op == 1) {
        String[] arr = h.getNgayLapHD().toString().split("T")[0].split("-");
        String ngayLap = arr[2] + "-" + arr[1] + "-" + arr[0];
        word = ngayLap;
      }
      if (op == 2) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = sf.format(calendar.getTime());
      }
      if (op == 3) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = String.valueOf(calendar.get(Calendar.MONTH) + 1);
      }

      if (!map.containsKey(word)) {
        map.put(word, h.tinhTongTien());
      } else {
        map.put(word, map.get(word) + h.tinhTongTien());
      }
    }
    return map;
  }

  private Map<String, Integer> mapSoLuongHoaDon(List<HoaDon> ds, int op) {
    Map<String, Integer> map = new TreeMap<>();
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");

    for (HoaDon h : ds) {
      int i = 1;
      String word = "";
      if (op == 2) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = sf.format(calendar.getTime());
      }
      if (op == 3) {
        calendar.setTime(Date
            .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
                .toInstant()));
        word = String.valueOf(calendar.get(Calendar.MONTH) + 1);
      }
      if (!map.containsKey(word)) {
        map.put(word, i);
      } else {
        map.put(word, map.get(word) + i);
      }
    }
    return map;
  }

  private void UpdataTableThongKe(List<HoaDon> ds) {

    double doanhThu = 0;

    String[] header = { "Mã hóa đơn", "Ngày lập hóa đơn", "Khách hàng", "Doanh thu (VND)" };

    tableModelThongKe = new DefaultTableModel(header, 0);
    tableModelThongKe.setRowCount(0);

    for (HoaDon h : ds) {

      doanhThu += h.tinhTongTien();

      String[] arr = h.getNgayLapHD().toString().split("T")[0].split("-");
      String ngayLap = arr[2] + "-" + arr[1] + "-" + arr[0];
      if (h.getKhachHang() == null) {
        String[] row = { h.getMaHD(), ngayLap, "Khách vãn lai",
            vn.format(h.tinhTongTien()), vn.format(h.tinhTongTien() * 0.1) };
        tableModelThongKe.addRow(row);
      } else {
        String[] row = { h.getMaHD(), ngayLap, h.getKhachHang().getTenKH(), vn.format(h.tinhTongTien()) };
        tableModelThongKe.addRow(row);
      }

    }
    tableThongKe.setModel(tableModelThongKe);
    tableThongKe.updateUI();

    lblValueDoanhThu.setText(vn.format(doanhThu) + " VND");
  }
}