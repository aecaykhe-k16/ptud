package ui;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Font;
import java.awt.GradientPaint;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.FileOutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.KeyStroke;
import javax.swing.filechooser.FileNameExtensionFilter;
import javax.swing.table.DefaultTableModel;

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

import bus.IHoaDonService;
import bus.IKhachHangService;
import bus.IPhongService;
import bus.implement.HoaDonImp;
import bus.implement.KhachHangImp;
import bus.implement.PhongImp;
import entities.ChiTietDichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiThanhVien;
import entities.NhanVien;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;
import util.Constants;
import util.PlaceholderTextField;
import util.SpecialButton;

public class ThanhToanHoaDon extends JFrame implements ActionListener {
  private JPanel pnlInfo;
  private PlaceholderTextField txtTimKiem;
  private JLabel lblTimKiem;
  private JButton btnTimKiem, btnBack, btnThanhToan;
  private DefaultTableModel model;
  private JTable table;

  private Cursor handleCursor;
  private IHoaDonService hoaDonService = new HoaDonImp();
  private IPhongService phongService = new PhongImp();
  private IKhachHangService khachHangService = new KhachHangImp();
  URL url = new URL(Constants.LOGO);
  Image imageIcon = new ImageIcon(url).getImage().getScaledInstance(100, 75, Image.SCALE_SMOOTH);
  private double vourcher1 = 5, vourcher2, vourcher3 = 100000;
  private NhanVien nv;
  KhachHang khachHang;

  public ThanhToanHoaDon(NhanVien nhanVien) throws MalformedURLException {
    nv = nhanVien;
    setTitle(Constants.APP_NAME);
    setSize(1200, 500);

    setLocationRelativeTo(null);
    setResizable(false);
    setIconImage(imageIcon);
    setLayout(null);
    handleCursor = new Cursor(Cursor.HAND_CURSOR);
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    pnlInfo = new JPanel();
    pnlInfo.setLayout(null);
    pnlInfo.setBounds(0, 0, 1200, 500);
    pnlInfo.setBackground(Color.WHITE);
    add(pnlInfo);

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
    pnl.setBounds(0, 0, 1200, 50);
    pnlInfo.add(pnl);
    JLabel lblTitle = new JLabel("Thanh toán hóa đơn đang sử dụng");
    lblTitle.setBounds(0, 0, 1200, 50);
    lblTitle.setFont(new Font("Arial", Font.PLAIN, 24));
    lblTitle.setForeground(Color.WHITE);
    lblTitle.setHorizontalAlignment(JLabel.CENTER);
    pnl.add(lblTitle);

    lblTimKiem = new JLabel("Số điện thoại");
    lblTimKiem.setBounds(50, 60, 150, 30);
    lblTimKiem.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(lblTimKiem);

    txtTimKiem = new PlaceholderTextField(Color.GRAY, false);
    txtTimKiem.requestFocus();
    txtTimKiem.setPlaceholder("Nhập số điện thoại");
    txtTimKiem.setText("");
    txtTimKiem.setBounds(50, 90, 300, 30);
    txtTimKiem.setFont(new Font("Arial", Font.PLAIN, 16));
    pnlInfo.add(txtTimKiem);

    btnTimKiem = new SpecialButton(10, Color.decode("#9dade4"), null);
    btnTimKiem.setBounds(370, 90, 150, 30);
    btnTimKiem.setText("Tìm kiếm");
    btnTimKiem.setIcon(FontIcon.of(FontAwesomeSolid.SEARCH, 20));
    btnTimKiem.setFont(new Font("Arial", Font.PLAIN, 16));
    btnTimKiem.setCursor(handleCursor);
    btnTimKiem.setBorderPainted(false);
    btnTimKiem.setContentAreaFilled(false);
    btnTimKiem.setFocusPainted(false);
    btnTimKiem.addActionListener(this);
    pnlInfo.add(btnTimKiem);

    btnThanhToan = new SpecialButton(10, Color.decode("#9dade4"), null);
    btnThanhToan.setBounds(1000, 90, 150, 30);
    btnThanhToan.setText("Thanh toán");
    btnThanhToan.setIcon(FontIcon.of(FontAwesomeSolid.PRINT, 20));
    btnThanhToan.setFont(new Font("Arial", Font.PLAIN, 16));
    btnThanhToan.setCursor(handleCursor);
    btnThanhToan.setBorderPainted(false);
    btnThanhToan.setContentAreaFilled(false);
    btnThanhToan.setFocusPainted(false);
    btnThanhToan.addActionListener(this);
    pnlInfo.add(btnThanhToan);

    String[] header = { "Mã hóa đơn", "Tên khách hàng", "SDT", "Tên nhân viên", "Tên phòng", "Giờ vào", "Giá phòng",
        "maLTV", "maPhong" };
    model = new DefaultTableModel(header, 0);
    table = new JTable(model);
    table.setFont(new Font("Arial", Font.PLAIN, 16));
    table.setRowHeight(30);
    table.getColumnModel().getColumn(7).setMinWidth(0);
    table.getColumnModel().getColumn(7).setMaxWidth(0);
    table.getColumnModel().getColumn(7).setWidth(0);
    table.getColumnModel().getColumn(8).setMinWidth(0);
    table.getColumnModel().getColumn(8).setMaxWidth(0);
    table.getColumnModel().getColumn(8).setWidth(0);
    table.getColumnModel().getColumn(0).setPreferredWidth(100);
    table.getColumnModel().getColumn(1).setPreferredWidth(150);
    table.getColumnModel().getColumn(2).setPreferredWidth(100);
    table.setDefaultEditor(Object.class, null);
    JScrollPane scrollPane = new JScrollPane(table);
    scrollPane.setBounds(50, 150, 1100, 300);
    pnlInfo.add(scrollPane);
    loadData();
    btnBack = new JButton();
    btnBack.setBorder(null);
    btnBack.setBorderPainted(false);
    btnBack.setContentAreaFilled(false);
    btnBack.setFocusPainted(false);
    btnBack.setOpaque(false);
    btnBack.setCursor(handleCursor);
    pnlInfo.add(btnBack);
    btnBack.addActionListener(this);
    btnBack.getInputMap(JComponent.WHEN_IN_FOCUSED_WINDOW).put(KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
        "btnBack");
    btnBack.getActionMap().put("btnBack", new AbstractAction() {
      @Override
      public void actionPerformed(ActionEvent e) {
        btnBack.doClick();
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

  private void loadData() {
    model.setRowCount(0);
    List<Map<String, Object>> list = hoaDonService.dsThanhToan();
    try {
      for (Map<String, Object> map : list) {
        String maLoai = map.get("maloaiTV") != null ? map.get("maloaiTV").toString().trim() : "";
        double giaPhong = Double.parseDouble(map.get("giaPhong").toString());
        String[] time = map.get("ngayLapHD").toString().split(" ")[1].split("\\.")[0].split("\\:");

        Object[] row = { map.get("maHD"), map.get("tenKH"), map.get("sdt"),
            map.get("tenNV"), map.get("tenPhong"),
            time[0] + ":" + time[1],
            String.valueOf(giaPhong).split("\\.")[0] + "VNĐ", maLoai, map.get("maPhong").toString() };
        model.addRow(row);
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @Override
  public void actionPerformed(ActionEvent e) {
    if (e.getSource() == btnBack) {
      this.dispose();
    } else if (e.getSource() == btnTimKiem) {
      String text = txtTimKiem.getText();
      for (int i = 0; i < model.getRowCount(); i++) {
        if (!model.getValueAt(i, 2).toString().equals(text)) {
          model.removeRow(i);
          i--;
        }
      }
      txtTimKiem.setText("");
    } else if (e.getSource() == btnThanhToan) {
      int thongBao = JOptionPane.showConfirmDialog(null, "Bạn có muốn thanh toán hết hóa đơn không?", "Thông báo",
          JOptionPane.YES_NO_OPTION);
      if (thongBao == JOptionPane.YES_OPTION) {
        double tongTien = 0;
        for (int i = 0; i < model.getRowCount(); i++) {
          for (HoaDon hoaDon : hoaDonService.dsHoaDon()) {
            if (hoaDon.getMaHD().trim().equals(table.getValueAt(i, 0).toString().trim())) {
              for (ChiTietDichVu dv : hoaDon.getCTDV()) {
                tongTien += dv.getSoLuong() * dv.getDichVu().getGiaDichVu();
              }
            }
          }
        }
        double tienTruocGiamGia = 0;
        String uuDai = "Không có";
        String txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
        String txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
        String txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
        for (int i = 0; i < model.getRowCount(); i++) {
          double tienPhong = Double.parseDouble(model.getValueAt(i, 6).toString().split("VNĐ")[0]);
          int gio = Integer.parseInt(table.getValueAt(i, 5).toString().split(":")[0]);
          int phut = Integer.parseInt(table.getValueAt(i, 5).toString().split(":")[1]);
          LocalTime gioKetThuc = LocalTime.now();
          long tongGio = (long) ((gioKetThuc.getHour()) - gio);
          long tongPhut = (long) (gioKetThuc.getMinute() - phut);
          if (phut < 0) {
            phut = 60 + phut;
            gio--;
          }
          double tien = (tongGio * tienPhong + tongPhut * tienPhong / 60);
          hoaDonService.capNhatChiTietHoaDon((int) (tongGio * 60 + tongPhut),
              table.getValueAt(i, 0).toString().trim());
          phongService.traPhong(table.getValueAt(i, 8).toString(),
              TrangThaiPhongEnum.TRONG.name());
          tongTien += tien;
          tienTruocGiamGia = tongTien;
          for (KhachHang kh : khachHangService.dsKH()) {
            if (kh.getLoaiTV().getMaLoaiTV().equals(table.getValueAt(i, 7))) {
              khachHang = kh;
              if (kh.getLoaiTV().getUuDai() == 1) {
                uuDai = (txt1);
                tongTien = tongTien * 0.95;
              } else if (kh.getLoaiTV().getUuDai() == 2) {
                vourcher2 = 1;
                txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
                uuDai = (txt1 + " + " + txt2);
                tongTien = tongTien * 0.95 - tienPhong;
              } else if (kh.getLoaiTV().getUuDai() == 3) {
                txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
                txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
                txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
                uuDai = (txt1 + " + " + txt2 + " + " + txt3);
                tongTien = tongTien * 0.95 - tienPhong - 100000;
              } else if (kh.getLoaiTV().getUuDai() == 4) {
                vourcher2 = 1;
                vourcher3 = vourcher3 + 100000;
                txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
                txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
                txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
                uuDai = (txt1 + " + " + txt2 + " + " + txt3);
                tongTien = tongTien * 0.95 - tienPhong - 200000;
              } else if (kh.getLoaiTV().getUuDai() == 5) {
                vourcher2 = 1;
                vourcher3 = vourcher3 + 400000;
                txt1 = String.valueOf(vourcher1).split("\\.")[0] + " %";
                txt2 = String.valueOf(vourcher2).split("\\.")[0] + " giờ";
                txt3 = String.valueOf(vourcher3).split("\\.")[0] + " VNĐ";
                uuDai = (txt1 + " + " + txt2 + " + " + txt3);
                tongTien = tongTien * 0.95 - tienPhong - 500000;
              }
            }
          }
        }
        if (tienTruocGiamGia >= 1500000 && tienTruocGiamGia < 5000000) {
          khachHang.setLoaiTV(new LoaiThanhVien("Bạc", 2));
          khachHangService.capNhatLoaiTV(khachHang);
        } else if (tienTruocGiamGia >= 5000000 && tienTruocGiamGia < 10000000) {
          khachHang.setLoaiTV(new LoaiThanhVien("Vàng", 3));
          khachHangService.capNhatLoaiTV(khachHang);
        } else if (tienTruocGiamGia >= 10000000 && tienTruocGiamGia < 15000000) {
          khachHang.setLoaiTV(new LoaiThanhVien("Bạch kim", 4));
          khachHangService.capNhatLoaiTV(khachHang);
        } else if (tienTruocGiamGia >= 15000000) {
          khachHang.setLoaiTV(new LoaiThanhVien("Kim cương", 5));
          khachHangService.capNhatLoaiTV(khachHang);
        }
        String[][] purchase = new String[3][2];
        purchase[0][0] = "Tổng tiền";
        purchase[0][1] = String.valueOf(tienTruocGiamGia).split("\\.")[0] + " VNĐ";
        purchase[1][0] = "Voucher";
        purchase[1][1] = uuDai;
        purchase[2][0] = "Tổng tiền thanh toán";
        purchase[2][1] = String.valueOf(tongTien).split("\\.")[0] + " VNĐ";
        int xemFile = JOptionPane.showConfirmDialog(null, "Thanh toán thành công. Bạn có muốn xem file không?",
            "Thông báo", JOptionPane.YES_NO_OPTION);
        if (xemFile == JOptionPane.YES_OPTION) {
          exportFilePDF(purchase);
        }
        this.dispose();
      }
    }

  }

  public void exportFilePDF(String[][] purchase) {
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

      com.itextpdf.text.Font fontBoldColor = null;
      com.itextpdf.text.Font fontBold = null;
      com.itextpdf.text.Font fontPDFSmall = null;
      com.itextpdf.text.Font fontPDFSmallItalic = null;
      try {
        FileOutputStream file = new FileOutputStream(chooser.getSelectedFile() + ".pdf");
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

        Paragraph tenNV = new Paragraph(nv.getTenNV(), fontPDFSmallItalic);
        tenNV.setIndentationLeft(295);
        document.add(tenNV);

        Paragraph titleHD = new Paragraph("Hóa đơn thanh toán", fontBold);
        titleHD.setAlignment(Element.ALIGN_CENTER);
        titleHD.setSpacingAfter(25);
        document.add(titleHD);

        PdfPTable tbl = new PdfPTable(table.getColumnCount() - 2);
        tbl.setWidthPercentage(90); // set table width to 90%

        for (int i = 0; i < table.getColumnCount() - 2; i++) {

          PdfPCell cell = new PdfPCell(new Paragraph(table.getColumnName(i), fontPDFSmall));
          cell.setHorizontalAlignment(Element.ALIGN_CENTER);
          tbl.addCell(cell);
        }
        for (int rows = 0; rows < table.getRowCount(); rows++) {
          for (int cols = 0; cols < table.getColumnCount() - 2; cols++) {
            PdfPCell cell = new PdfPCell(new Paragraph(table.getModel().getValueAt(rows, cols).toString(),
                fontPDFSmall));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            tbl.addCell(cell);
          }
        }
        tbl.setSpacingAfter(10);
        if (table.getRowCount() > 0) {
          document.add(tbl);
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

        Desktop.getDesktop().open(new File(chooser.getSelectedFile() + ".pdf"));

      } catch (Exception e) {
        JOptionPane.showMessageDialog(null, "Xuất file thất bại");
        e.printStackTrace();
      }

    }

  }

}
