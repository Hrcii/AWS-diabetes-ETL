import json
from pathlib import Path
import numpy as np
from sklearn.datasets import load_diabetes
from sklearn.model_selection import train_test_split
from sklearn.svm import SVR
import time
from datetime import datetime
from config import SVRConfig

config = SVRConfig()

dataset = load_diabetes()
X, y = dataset.data, dataset.target
feature_names = dataset.feature_names

indices = np.arange(len(X))
train_idx, test_idx = train_test_split(
    indices,
    test_size=config.TEST_SIZE,
    random_state=config.RANDOM_STATE,
    shuffle=True,
)

X_train, y_train = X[train_idx], y[train_idx]
X_test, y_test = X[test_idx], y[test_idx]

gamma = 10 ** np.random.uniform(low = config.GAMMA_EXP_MIN, high = config.GAMMA_EXP_MAX)
c = 10 ** np.random.uniform(low = config.C_EXP_MIN, high = config.C_EXP_MAX)
eps = 10 ** np.random.uniform(low = config.EPSILON_EXP_MIN, high = config.EPSILON_EXP_MAX)
hyper_id = int(time.time())

timestamp = datetime.now().strftime("%Y-%m-%d_%H_%M_%S")
output_path = Path(f"{timestamp}_hyper.json")

#hyperparam dimension table
with output_path.open("w", encoding="utf-8") as stream:
    record = {
        "hyper_id": hyper_id,
        "gamma": gamma,
        "C": c,
        "epsilon": eps  
    }
    stream.write(json.dumps(record, separators=(",", ":")))


svr = SVR(kernel="rbf", gamma=gamma, C=c, epsilon=eps)
svr.fit(X_train,y_train)

y_pred_train = svr.predict(X_train)
y_pred_test = svr.predict(X_test)

output_path = Path(f"{timestamp}_fact.json")

with output_path.open("w", encoding="utf-8") as stream:
    # training rows
    for idx, y_pred_val in zip(train_idx, y_pred_train):
        record = {
            "hyper_id": hyper_id,
            "point_id": int(idx),
            "y_pred": float(y_pred_val),
        }
        stream.write(json.dumps(record, separators=(",", ":")) + "\n")

    # test rows
    for idx, y_pred_val in zip(test_idx, y_pred_test):
        record = {
            "hyper_id": hyper_id,
            "point_id": int(idx),
            "y_pred": float(y_pred_val),
        }
        stream.write(json.dumps(record, separators=(",", ":")) + "\n")
