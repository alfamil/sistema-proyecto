import os
import qrcode
from PIL import Image

def generar_codigo_qr(url: str, output_path: str = "qr_sistema.png"):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,  # Alta corrección de errores (30%)
        box_size=12,  # Tamaño de cada cuadro/píxel
        border=4,     # Grosor del borde en cuadros
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    img.save(output_path)
    print(f"Código QR generado con éxito en: {os.path.abspath(output_path)}")

if __name__ == "__main__":
    url_objetivo = "https://sistema-proyecto-three.vercel.app/"
    generar_codigo_qr(url_objetivo, "qr_sistema.png")
