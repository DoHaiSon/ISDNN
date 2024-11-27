import numpy as np
from scipy.linalg import pinv
import timeit

Nt = 8
Nr = 64
SNR = 15
num_exp = 100
running_time = 0

def qammod(data, M):
    """QAM Modulation"""
    return (2*(data % np.sqrt(M)) - np.sqrt(M) + 1) + 1j*(2*(data // np.sqrt(M)) - np.sqrt(M) + 1)

def awgn(signal, snr_dB):
    """Additive White Gaussian Noise (AWGN)"""
    snr_linear = 10**(snr_dB / 10)
    signal_power = np.mean(np.abs(signal)**2)
    noise_power = signal_power / snr_linear
    noise = np.sqrt(noise_power / 2) * (np.random.randn(*signal.shape) + 1j * np.random.randn(*signal.shape))
    return signal + noise

rt = []

for idx in range (100):
    for idx in range(num_exp):
        # Generate pilot: QAM-16 symbols, 1 x Nt
        data = np.random.randint(0, 16, Nt)
        x = qammod(data, 16) / 3
        
        # Convert x to a 2D array with shape (1, Nt)
        x = x.reshape(1, Nt)
        
        # Generate channel: rand(H), Nt x Nr
        H = (np.random.randn(Nt, Nr) + 1j * np.random.randn(Nt, Nr)) / np.sqrt(2)
        
        # Receive signal w/o noise
        y = np.dot(x, H)
        
        # Add noise
        y_n = awgn(y, SNR)
        
        start = timeit.default_timer()
        # LS estimator
        H_LS_est = np.dot(pinv(np.dot(x.T.conj(), x)), np.dot(x.T.conj(), y_n))

        running_time += timeit.default_timer() - start

    rt.append(running_time)
    running_time = 0
print(np.average(rt) / num_exp)