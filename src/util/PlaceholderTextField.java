package util;

import java.awt.*;

import javax.swing.*;
import javax.swing.text.Document;

public class PlaceholderTextField extends JTextField {

  private String placeholder;
  private Color color;
  private boolean trangThai;

  public PlaceholderTextField(Color color, boolean trangThai) {
    this.color = color;
    this.trangThai = trangThai;
  }

  public PlaceholderTextField(
      final Document pDoc,
      final String pText,
      final int pColumns) {
    super(pDoc, pText, pColumns);
  }

  public PlaceholderTextField(final int pColumns) {
    super(pColumns);
  }

  public PlaceholderTextField(final String pText) {
    super(pText);
  }

  public PlaceholderTextField(final String pText, final int pColumns) {
    super(pText, pColumns);
  }

  public String getPlaceholder() {
    return placeholder;
  }

  @Override
  protected void paintComponent(final Graphics pG) {
    super.paintComponent(pG);

    if (placeholder == null || placeholder.length() == 0 || getText().length() > 0) {
      return;
    }

    final Graphics2D g = (Graphics2D) pG;
    g.setRenderingHint(
        RenderingHints.KEY_ANTIALIASING,
        RenderingHints.VALUE_ANTIALIAS_ON);
    g.setColor(color);

    g.setFont(new Font("Arial", Font.PLAIN, 15));
    if (trangThai) {
      g.drawString(placeholder, getInsets().left, pG.getFontMetrics()
          .getMaxAscent() + getInsets().top + 15);
    } else {
      g.drawString(placeholder, getInsets().left + 2, pG.getFontMetrics()
          .getMaxAscent() + getInsets().top + 5);
    }
  }

  public void setPlaceholder(final String s) {
    placeholder = s;
  }

}