import sys
from pathlib import Path

from PyQt6.QtCore import Qt
from PyQt6.QtWidgets import QApplication

from mik_aml.burn_window import BurnWindow
from mik_aml.mik_window import MikWindow


def main() -> None:
    app = QApplication(sys.argv)
    app.setAttribute(Qt.ApplicationAttribute.AA_DontUseNativeMenuBar, True)
    app.setStyle("Fusion")
    which = sys.argv[1] if len(sys.argv) > 1 else "mik"
    if which == "burn":
        win = BurnWindow()
        if len(sys.argv) > 2:
            win.load_image(Path(sys.argv[2]))
    else:
        win = MikWindow()
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
