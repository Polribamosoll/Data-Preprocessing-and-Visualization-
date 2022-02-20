### LEARNING DIARY 3

# Install the needed packages

import pandas as pd
import matplotlib.pyplot as plt
import sklearn
from matplotlib.ticker import MaxNLocator
from matplotlib.pyplot import figure
import numpy as np
from matplotlib.dates import AutoDateFormatter, AutoDateLocator

# Import the data

dataset = pd.read_csv(r"C:\Users\polri\Desktop\TFG\Ciutats_Espanyoles\Barcelona\AirQuality_Barcelona.csv", sep = ";", na_values = " ")

# Check for missing values, and impute them with a 0 value (just to learn how to impute, I know it is not the best decision)

print(dataset.isna().sum())
dataset = dataset.fillna(0)
print(dataset.isna().sum())

# Data preprocessing: Normalization and standardization

from sklearn import preprocessing
for name in dataset.columns[1:]:
    x = dataset[name].values
    x = np.reshape(x, (x.shape[0],1))
    min_max_scaler = preprocessing.MinMaxScaler()
    x_scaled= min_max_scaler.fit_transform(x)
    scaler = preprocessing.StandardScaler().fit_transform(x_scaled)
    dataset[name] = pd.DataFrame(scaler)
print(dataset)

# Visualization

import matplotlib.pyplot as plt 

for name in dataset.columns[1:]:
    plt.plot(dataset[name])
    plt.xlabel("Time Series")
    plt.ylabel("Value")
    plt.show()

