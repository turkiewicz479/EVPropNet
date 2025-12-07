# EVPropNet � uruchomienie testu na danych przyk�adowych (sample data)

Projekt wykorzystuje publiczne repozytorium [EVPropNet](https://github.com/prgumd/EVPropNet), kt�re zawiera sie� neuronow� do detekcji �migie� dron�w na danych z kamery zdarzeniowej.  

Poni�ej opisano krok po kroku, jak uruchomi� testowy skrypt na sample data, korzystaj�c z Dockera.

---

## 1. Wymagania

Na komputerze u�ytkownika powinny by� zainstalowane:

- Linux (sprawdzone na Ubuntu 20.04 / 22.04)
- `git`
- `docker`  
- (opcjonalnie) wsparcie GPU dla Dockera � `nvidia-container-toolkit` + sterowniki NVIDIA, je�li chcemy korzysta� z GPU

> Wszystkie biblioteki Pythona (TensorFlow 1.14, OpenCV, NumPy itp.) s� zawarte w obrazie Dockera, wi�c nie trzeba ich instalowa� lokalnie.

---

## 2. Sklonowanie repozytorium

```bash
git clone https://github.com/prgumd/EVPropNet.git
cd EVPropNet

## 3. Budowa obrazu Dockera

Zbuduj obraz:
docker build -t evpropnet .

## 4. Pobranie sample data

Wejd� w wiki: Test Code On Sample Data ? sekcja Download Sample Data.
Pobierz:
� symulowane dane (Simulated data),
� realne dane (Real data).
Rozpakuj (przyk�adowo):
mkdir -p data/DVSPropTest data/RealData
unzip DVSPropTest.zip -d data/DVSPropTest
unzip RealData.zip   -d data/RealData

## 5. Pobranie modelu (checkpoint):
W wiki w sekcji Download the model pobierz model (Float). Umie� pliki modelu w katalogu, np.:
CheckPoints/SingleStyleProp/
    49model.ckpt.data-00000-of-00001
    49model.ckpt.index
    49model.ckpt.meta

## 6. Uruchomienie konteneru Dockera:
Z katalogu g��wnego repo:
docker run --rm -it \
  --name evpropnet \
  -v "$(pwd)":/workspace \
  --gpus all \
  evpropnet bash

(Je�li nie u�ywasz GPU, usu� --gpus all.)

## 7. Test na pojedynczym obrazie (Single, TestMode=S)
mkdir -p /workspace/Outputs
Uruchom:
python3 /workspace/Code/Test.py \
  --CheckPointPath=/workspace/CheckPoints/SingleStyleProp/49model.ckpt \
  --WritePath=/workspace/Outputs/ \
  --TestMode=S \
  --Input=/workspace/data/DVSPropTest/Imgs/000000.png
(000000 to nazwa pliku,; je�eli chcemy inny plik to musimy poda� jego nazwe)

## 8. Test na wielu obrazach (Multiple, TestMode=M)
python3 /workspace/Code/Test.py \
  --CheckPointPath=/workspace/CheckPoints/SingleStyleProp/49model.ckpt \
  --WritePath=/workspace/Outputs/ \
  --TestMode=M \
  --Input=/workspace/data/DVSPropTest/Imgs/ \
  --ImgFormat=png

## 9. Sprawdzenie wynik�w
Pliki wyj�ciowe znajduj� si� w folderze Outputs
