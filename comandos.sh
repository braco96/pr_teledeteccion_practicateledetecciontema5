#!/usr/bin/env bash
set -euo pipefail

# === Parámetros de ejemplo (ajusta rutas a tus datos) ===
PAN="datos/pan.tif"          # Pancromática (alta resolución)
MS="datos/ms.tif"            # Multiespectral (baja resolución, 3 o 4 bandas)
SALIDA="salidas"
mkdir -p "$SALIDA"

echo "Comprobando dependencias..."
command -v gdalinfo >/dev/null || { echo "Falta gdalinfo (GDAL)."; exit 1; }
command -v otbcli_Pansharpening >/dev/null || echo "Aviso: intenta 'otbcli_BundleToPerfectSensor' si tu OTB no trae 'otbcli_Pansharpening'."
echo "OK"

echo "=== Inspección de datos ==="
gdalinfo "$PAN" | head -n 20 || true
gdalinfo "$MS"  | head -n 20 || true

echo "=== Reescalar a 8 bits (si procede) ==="
gdal_translate -ot Byte -scale 0 65535 0 255 "$PAN" "$SALIDA/pan_8b.tif"
gdal_translate -ot Byte -scale 0 65535 0 255 "$MS"  "$SALIDA/ms_8b.tif"

echo "=== Fusión IHS (ejemplo) ==="
if command -v otbcli_Pansharpening >/dev/null; then
  otbcli_Pansharpening -method ihs -inp "$SALIDA/ms_8b.tif" -inpan "$SALIDA/pan_8b.tif" -out "$SALIDA/fusion_ihs.tif"
else
  # Alternativa común en OTB
  otbcli_BundleToPerfectSensor -inp "$SALIDA/ms_8b.tif" -inpan "$SALIDA/pan_8b.tif" -method ihs -out "$SALIDA/fusion_ihs.tif"
fi

echo "=== Fusión PCA (ejemplo) ==="
if command -v otbcli_Pansharpening >/dev/null; then
  otbcli_Pansharpening -method pca -inp "$SALIDA/ms_8b.tif" -inpan "$SALIDA/pan_8b.tif" -out "$SALIDA/fusion_pca.tif"
else
  otbcli_BundleToPerfectSensor -inp "$SALIDA/ms_8b.tif" -inpan "$SALIDA/pan_8b.tif" -method pca -out "$SALIDA/fusion_pca.tif"
fi

echo "=== Métricas básicas (aprox.) ==="
gdalinfo "$SALIDA/fusion_ihs.tif" | grep -E "Size is|Band|Type" || true
gdalinfo "$SALIDA/fusion_pca.tif" | grep -E "Size is|Band|Type" || true

echo "Hecho."

