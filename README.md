# PracticaTeledetecciontema5

## Resumen
Repositorio independiente que empaqueta la memoria original, un README con la metodología seguida y un guion de comandos reproducibles (gdal/otb) para la práctica.

## Objetivos
- Dejar un proyecto autocontenido listo para versionar en GitHub.
- Documentar datos de entrada, pasos y salidas esperadas.
- Proveer comandos CLI que permitan repetir el flujo sin interfaz gráfica.

## Metodología
Se reproducen dos enfoques de fusión pansharpening descritos en la memoria: IHS y PCA. Para automatización se sugieren utilidades de GDAL y Orfeo Toolbox (OTB). Los parámetros por defecto usan 8 bits por píxel y, cuando aplica, interpolación lineal.

## Estructura del repositorio
```
.
├─ Memoria.docx
├─ README.md
└─ comandos.sh
```

## Requisitos
- Python 3 (opcional)
- GDAL (>= 3.x) y Orfeo Toolbox (OTB) instalados y en el `PATH`
- Bash (Linux/macOS) o WSL en Windows

## Ejecución
```bash
chmod +x comandos.sh
./comandos.sh
```

## Notas
- **IHS**: ejemplo con `otbcli_Pansharpening`/`otbcli_BundleToPerfectSensor` indicando método IHS.
- **PCA**: ejemplo con `otbcli_Pansharpening` indicando método PCA.
