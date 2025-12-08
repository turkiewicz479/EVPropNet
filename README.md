# EVPropNet – uruchomienie testu na danych przykładowych (sample data)

Projekt wykorzystuje publiczne repozytorium [EVPropNet](https://github.com/prgumd/EVPropNet), które zawiera sieć neuronową do detekcji śmigieł dronów na danych z kamery zdarzeniowej.  

Poniżej opisano krok po kroku, jak uruchomić testowy skrypt na sample data, korzystając z Dockera.

---

## 1. Wymagania

Na komputerze użytkownika powinny być zainstalowane:

- Linux (sprawdzone na Ubuntu 20.04 / 22.04)
- `git`
- `docker`  
- (opcjonalnie) wsparcie GPU dla Dockera – `nvidia-container-toolkit` + sterowniki NVIDIA, jeśli chcemy korzystać z GPU

> Wszystkie biblioteki Pythona (TensorFlow 1.14, OpenCV, NumPy itp.) są zawarte w obrazie Dockera, więc nie trzeba ich instalować lokalnie.

---

## 2. Sklonowanie repozytorium


git clone https://github.com/prgumd/EVPropNet.git
cd EVPropNet
---
## 3. Budowa obrazu Dockera

Zbuduj obraz:
docker build -t evpropnet .
---
## 4. Pobranie sample data

Wejdź w wiki: Test Code On Sample Data → sekcja Download Sample Data.
Pobierz:
•	symulowane dane (Simulated data),
•	realne dane (Real data).
Rozpakuj (przykładowo):
mkdir -p data/DVSPropTest data/RealData
unzip DVSPropTest.zip -d data/DVSPropTest
unzip RealData.zip   -d data/RealData
---
## 5. Pobranie modelu (checkpoint):
W wiki w sekcji Download the model pobierz model (Float). Umieść pliki modelu w katalogu, np.:
CheckPoints/SingleStyleProp/
    49model.ckpt.data-00000-of-00001
    49model.ckpt.index
    49model.ckpt.meta
---    
## 6. Uruchomienie konteneru Dockera:
Z katalogu głównego repo:
docker run --rm -it \
  --name evpropnet \
  -v "$(pwd)":/workspace \
  --gpus all \
  evpropnet bash

(Jeśli nie używasz GPU, usuń --gpus all.)
---
## 7. Test na pojedynczym obrazie (Single, TestMode=S)
mkdir -p /workspace/Outputs
Uruchom:
python3 /workspace/Code/Test.py \
  --CheckPointPath=/workspace/CheckPoints/SingleStyleProp/49model.ckpt \
  --WritePath=/workspace/Outputs/ \
  --TestMode=S \
  --Input=/workspace/data/DVSPropTest/Imgs/000000.png
(000000 to nazwa pliku,; jeżeli chcemy inny plik to musimy podać jego nazwe)
---
## 8. Test na wielu obrazach (Multiple, TestMode=M)
python3 /workspace/Code/Test.py \
  --CheckPointPath=/workspace/CheckPoints/SingleStyleProp/49model.ckpt \
  --WritePath=/workspace/Outputs/ \
  --TestMode=M \
  --Input=/workspace/data/DVSPropTest/Imgs/ \
  --ImgFormat=png
---
## 9. Sprawdzenie wyników
Pliki wyjściowe znajdują się w Outputs
```bash