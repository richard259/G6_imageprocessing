import numpy as np
import os
from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt

def load_dataset(name, n_train=None, d=None, print_details=False):
    """
    Loads a specified dataset.

    Inputs:
        name : (str) name of the dataset as a string. Must be one
           of ['pumadyn32nm', 'iris', 'mnist_small', 'mauna_loa', 'rosenbrock'].
        n_train : (int, optional) if name='rosenbrock' the specify the number of training points
        d : (int, optional) if name='rosenbrock' the specify the dataset dimensionality
        print_details : (bool, optional) whether to print details about the dataset

    Outputs:
        x_train, x_valid, x_test, y_train, y_valid, y_test
    """
    assert isinstance(name, str), 'name must be a string.'
    assert name.lower() in ['boston',  'pumadyn32nm', 'iris', 'mnist_small', 'mauna_loa', 'rosenbrock'], 'name provided is invalid.'
    if name.lower() == 'rosenbrock':
        assert n_train is not None and d is not None, "n and d must be specified for the rosenbrock function"
        rng = np.random.RandomState(42) # random number generator with seed
        x_valid = rng.randn(1000, int(d))
        x_test = rng.randn(1000, int(d))
        x_train = rng.randn(int(n_train), int(d))
        y_valid = rosenbrock(x_valid)
        y_test = rosenbrock(x_test)
        y_train = rosenbrock(x_train)
        # scale response to zero mean and unit variance
        scaler = StandardScaler()
        y_train = scaler.fit_transform(y_train)
        y_test = scaler.fit_transform(y_test)
        y_valid = scaler.fit_transform(y_valid)
    else:
        assert n_train is None and d is None, "n and d must only be specified for the rosenbrock function"
        with np.load(os.path.join(os.path.dirname(__file__), name.lower()+'.npz')) as data:
             x_train=data['x_train']
             x_valid=data['x_valid']
             x_test=data['x_test']
             y_train=data['y_train']
             y_valid=data['y_valid']
             y_test=data['y_test']
    if name.lower() == 'mnist_small': # convert to float and normalize inputs
        # scale all pixels to be zero mean and unit variance in the training set
        x_scaler = StandardScaler()
        x_train = x_scaler.fit_transform(np.float64(x_train).reshape((-1,1))).reshape((10000, 784))
        x_test = x_scaler.transform(np.float64(x_test).reshape((-1,1))).reshape((1000, 784))
        x_valid = x_scaler.transform(np.float64(x_valid).reshape((-1,1))).reshape((1000, 784))
    # print dataset details
    if print_details:
        print("Dataset %s" % name)
        print("d = %d" % x_train.shape[1])
        print("n_train = %d" % x_train.shape[0])
        print("n_valid = %d" % x_valid.shape[0])
        print("n_test = %d" % x_test.shape[0])
    return x_train, x_valid, x_test, y_train, y_valid, y_test


def rosenbrock(x):
    """ returns rosenbrock function evaluated at a specified input location. """
    assert np.ndim(x) == 2, "x must be 2d."
    assert x.shape[0] >= 1 and x.shape[1] >= 2, "must have a least n=1 training point and at least d=2 input dimensions"
    return np.sum(100.0*np.square(x[:,1:]-np.square(x[:,:-1])) + np.square(1.-x[:,:-1]), axis=1, keepdims=True)


def plot_digit(x):
    """ plots a provided MNIST digit """
    assert np.size(x) == 784
    plt.imshow(x.reshape((28,28)), interpolation='none', aspect='equal', cmap='gray')

