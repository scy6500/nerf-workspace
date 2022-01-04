## ML Workspace
This branch is for creating Ainize Workspace images for machine learning developers or machine learning researcher.

### Development Extension
- [Jupyter Notebook and Lab](https://jupyter.org/)
- [Visual Studio Code](https://github.com/cdr/code-server)
- [Terminal - ttyd](https://github.com/tsl0922/ttyd)

### Major Package List
```
Package                           Version
--------------------------------- ---------------------
jax                               0.2.26
keras                             2.7.0
lightgbm                          3.3.1
nltk                              3.6.7
numba                             0.54.1
numpy                             1.20.3
pandas                            1.3.5
scikit-learn                      1.0.2
scipy                             1.7.3
seaborn                           0.11.2
tensorflow                        2.7.0
torch                             1.10.1
tqdm                              4.62.3
xgboost                           1.5.0
```

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

* Jupyter Notebook : http://server-address:8000/
* Visual Studio Code : http://server-address:8010/
* Terminal - ttyd : http://server-address:8020/

* You can download this image from [Docker Hub](https://hub.docker.com/repository/docker/byeongal/ainize-workspace-ml-workspace).

### How to use this image in Ainize Workspace
1. Click the "Create your workspace" button on the [Ainize Workspace page](https://ainize.ai/workspace).
2. As the Container option, select "Import from github".
3. Click the "Start with repo url" button.
4. Put "https://github.com/ainize-workspace-collections/ml-workspace" in "Enter a Github repo url". And select the "2022.01-dev" branch.
5. Select the required tool(s) and click the OK button.
6. Click "Start my work" after selecting the machine type.
Now, enjoy your own Ainize Workspace! 🎉

