import json
from dataclasses import dataclass
from pathlib import Path
import numpy as np
from sklearn.datasets import load_diabetes
from sklearn.model_selection import train_test_split
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

is_train = np.zeros(len(X), dtype=bool)
is_train[train_idx] = True

output_path = Path("../diabetes_data/diabetes_data.json")
output_path.parent.mkdir(parents=True, exist_ok=True)

with output_path.open("w", encoding="utf-8") as stream:
    for idx, (features, truth) in enumerate(zip(X, y)):
        record = {"point_id": int(idx), "is_train": bool(is_train[idx])}
        record.update({name: float(value) for name, value in zip(feature_names, features)})
        record["y_true"] = float(truth)
        stream.write(json.dumps(record, separators=(",", ":")) + "\n")
