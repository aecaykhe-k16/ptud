package util;

import java.awt.*;

import javax.swing.*;
import javax.swing.text.Document;

public class PlaceholderPassword extends JPasswordField {

  private String placeholder;
  private boolean trangThai;

  public PlaceholderPassword(boolean trangThai) {
    this.trangThai = trangThai;

  }

  public PlaceholderPassword(
      final Document pDoc,
      final String pText,
      final int pColumns) {
    super(pDoc, pText, pColumns);
  }

  public PlaceholderPassword(final int pColumns) {
    super(pColumns);
  }

  public PlaceholderPassword(final String pText) {
    super(pText);
  }

  public PlaceholderPassword(final String pText, final int pColumns) {
    super(pText, pColumns);
  }

  public String getPlaceholder() {
    return placeholder;
  }

  @Override
  protected void paintComponent(final Graphics pG) {
    super.paintComponent(pG);

    if (placeholder == null || placeholder.length() == 0 || String.valueOf(getPassword()).length() > 0) {
      return;
    }

    final Graphics2D g = (Graphics2D) pG;
    g.setRenderingHint(
        RenderingHints.KEY_ANTIALIASING,
        RenderingHints.VALUE_ANTIALIAS_ON);
    g.setColor(Color.decode("#EEF1FF"));
    g.setFont(new Font("Arial", Font.PLAIN, 15));
    if (trangThai) {
      g.drawString(placeholder, getInsets().left, pG.getFontMetrics()
          .getMaxAscent() + getInsets().top + 15);
    } else {
      g.drawString(placeholder, getInsets().left, pG.getFontMetrics()
          .getMaxAscent() + getInsets().top);
    }
  }

  public void setPlaceholder(final String s) {
    placeholder = s;
  }

}