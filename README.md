<h1 align="center">
    ML Workspace
    <br>
</h1>

This branch is for creating Ainize Workspace images for machine learning developers or machine learning researcher.

## Installed Python libraries

<details><summary><b>Machine Learning Frameworks</b></summary>

- [Tensorflow](https://github.com/tensorflow/tensorflow)
- [scikit-learn](https://github.com/scikit-learn/scikit-learn)
- [PyTorch](https://github.com/pytorch/pytorch)
- [Keras](https://github.com/keras-team/keras)
- [XGBoost](https://github.com/dmlc/xgboost)
- [LightGBM](https://github.com/microsoft/LightGBM)
- [JAX](https://github.com/google/jax)
- [Pytorch-lightning](https://github.com/PyTorchLightning/pytorch-lightning)
- [StatsModels](https://github.com/statsmodels/statsmodels)
- [LightGBM](https://github.com/microsoft/LightGBM)

</details>

<details><summary><b>Data Visualization</b></summary>

- [Matplotlib](https://github.com/matplotlib/matplotlib)
- [Bokeh](https://github.com/ml-tooling/best-of-ml-python)
- [Plotly](https://github.com/plotly/plotly.py)
- [Seaborn](https://github.com/mwaskom/seaborn)
- [Dash](https://github.com/plotly/dash)
- [Altair](https://github.com/altair-viz/altair)
- [Pandas Profiling](https://github.com/ydataai/pandas-profiling)
- [HoloViews](https://github.com/holoviz/holoviews)
- [WordCloud](https://github.com/amueller/word_cloud)
- [missingno](https://github.com/ResidentMario/missingno)

</details>

<details><summary><b>Text Data & NLP</b></summary>

- [spaCy](https://github.com/explosion/spaCy)
- [nltk](https://github.com/nltk/nltk)
- [gensim](https://github.com/RaRe-Technologies/gensim)
- [snowballstemmer](https://github.com/snowballstem/snowball)

</details>

<details><summary><b>Image Data</b></summary>

- [Pillow](https://github.com/python-pillow/Pillow)
- [scikit-image](https://github.com/scikit-image/scikit-image)
- [torchvision](https://github.com/pytorch/vision)
- [MoviePy](https://github.com/Zulko/moviepy)
- [imageio](https://github.com/imageio/imageio)
- [opencv-python](https://github.com/opencv/opencv-python)
- [Albumentations](https://github.com/albumentations-team/albumentations)

</details>

<details><summary><b>Graph Data</b></summary>

- [networkx](https://github.com/networkx/networkx)

</details>

<details><summary><b>Geospatial Data</b></summary>

- [geopy](https://github.com/geopy/geopy)

</details>

<details><summary><b>Time Series Data</b></summary>

- [Prophet](https://github.com/facebook/prophet)

</details>

<details><summary><b>Data Containers & Dataframes</b></summary>

- [pandas](https://github.com/pandas-dev/pandas)
- [numpy](https://github.com/numpy/numpy)
- [h5py](https://github.com/h5py/h5py)
- [xarray](https://github.com/pydata/xarray)
- [Bottleneck](https://github.com/pydata/bottleneck)
- [numexpr](https://github.com/pydata/numexpr)

</details>

<details><summary><b>Data Pipelines & Streaming</b></summary>

- [joblib](https://github.com/joblib/joblib)

</details>

<details><summary><b>Distributed Machine Learning</b></summary>

- [dask](https://github.com/dask/dask)
- [distributed](https://github.com/dask/distributed)

</details>

<details><summary><b>Hyperparameter Optimization & AutoML</b></summary>

- [Hyperopt](https://github.com/hyperopt/hyperopt)

</details>

<details><summary><b>Reinforcement Learning</b></summary>

- [Dopamine](https://github.com/google/dopamine)

</details>

<details><summary><b>Workflow & Experiment Tracking</b></summary>

- [Tensorboard](https://github.com/tensorflow/tensorboard)

</details>

<details><summary><b>Model Interpretability</b></summary>

- [arviz](https://github.com/arviz-devs/arviz)
- [yellowbrick](https://github.com/DistrictDataLabs/yellowbrick)

</details>

<details><summary><b>Probabilistics & Statistics</b></summary>

- [PyMC3](https://github.com/pymc-devs/pymc)
- [tensorflow-probability](https://github.com/tensorflow/probability)
- [patsy](https://github.com/pydata/patsy)

</details>

<details><summary><b>Sklearn Utilities</b></summary>

- [imbalanced-learn](https://github.com/scikit-learn-contrib/imbalanced-learn)

</details>

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
4. Put "https://github.com/ainize-workspace-collections/ml-workspace" in "Enter a Github repo url". And select this branch.
5. Select the required tool(s) and click the OK button.
6. Click "Start my work" after selecting the machine type.
   Now, enjoy your own Ainize Workspace! 🎉
