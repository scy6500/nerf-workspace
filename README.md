<h1 align="center">
    ML Workspace
    <br>
</h1>

This branch is for creating Ainize Workspace images for machine learning developers or machine learning researcher.

## Installed Python libraries

### Machine Learning Frameworks

- [Tensorflow](https://github.com/tensorflow/tensorflow)
- [scikit-learn](https://github.com/scikit-learn/scikit-learn)
- [PyTorch](https://github.com/pytorch/pytorch)
- [Keras](https://github.com/keras-team/keras)
- [XGBoost](https://github.com/dmlc/xgboost)
- [LightGBM](https://github.com/microsoft/LightGBM)
- [JAX](https://github.com/google/jax)
- [Catboost](https://github.com/catboost/catboost)

### Data Visualization

- [Matplotlib](https://github.com/matplotlib/matplotlib)
- [Bokeh](https://github.com/ml-tooling/best-of-ml-python)
- [Plotly](https://github.com/plotly/plotly.py)
- [Seaborn](https://github.com/mwaskom/seaborn)
- [Altair](https://github.com/altair-viz/altair)
- [Pandas Profiling](https://github.com/ydataai/pandas-profiling)
- [HoloViews](https://github.com/holoviz/holoviews)
- [WordCloud](https://github.com/amueller/word_cloud)
- [missingno](https://github.com/ResidentMario/missingno)

### Text Data & NLP

- [nltk](https://github.com/nltk/nltk)
- [spaCy](https://github.com/explosion/spaCy)
- [gensim](https://github.com/RaRe-Technologies/gensim)
- [snowballstemmer](https://github.com/snowballstem/snowball)

### Image Data

- [Pillow](https://github.com/python-pillow/Pillow)
- [scikit-image](https://github.com/scikit-image/scikit-image)
- [torchvision](https://github.com/pytorch/vision)
- [imageio](https://github.com/imageio/imageio)
- [Albumentations](https://github.com/albumentations-team/albumentations)

### Graph Data

- [networkx](https://github.com/networkx/networkx)
- [geopy](https://github.com/geopy/geopy)

### Data Containers & Structures

- [pandas](https://github.com/pandas-dev/pandas)
- [numpy](https://github.com/numpy/numpy)
- [h5py](https://github.com/h5py/h5py)

### How to Test Your Image

Build Docker Image

```bash
docker build -t <image-name> .
```

Run Docker

```bash
docker run -d -p 8000:8000 -p 8010:8010 -p 8020:8020 <image-name>
```

Run Docker with Password

```bash
docker run -d -p 8000:8000 -p 8010:8010 -p 8020:8020 -e PASSWORD=<password> <image-name>
```

Run Docker with Github Repo

```bash
docker run -d -p 8000:8000 -p 8010:8010 -p 8020:8020 -e GH_REPO=<github-repo> <image-name>
```

Run Docker with password and Github Repo

```bash
docker run -d -p 8000:8000 -p 8010:8010 -p 8020:8020 -e PASSWORD=<password> -e GH_REPO=<github-repo> <image-name>
```

- Jupyter Notebook : http://server-address:8000/
- Visual Studio Code : http://server-address:8010/
- Terminal - ttyd : http://server-address:8020/

- You can download this image from [Docker Hub](https://hub.docker.com/repository/docker/byeongal/ainize-workspace-ml-workspace).

### How to use this image in Ainize Workspace

1. Click the "Create your workspace" button on the [Ainize Workspace page](https://ainize.ai/workspace).
2. As the Container option, select "Import from github".
3. Click the "Start with repo url" button.
4. Put "https://github.com/ainize-workspace-collections/ml-workspace" in "Enter a Github repo url". And select the "2022.01-dev" branch.
5. Select the required tool(s) and click the OK button.
6. Click "Start my work" after selecting the machine type.
   Now, enjoy your own Ainize Workspace! 🎉
