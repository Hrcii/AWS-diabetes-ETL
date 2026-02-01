from dataclasses import dataclass

@dataclass(frozen=True)
class SVRConfig:
    C_EXP_MIN: int = -2
    C_EXP_MAX: int = 2
    GAMMA_EXP_MIN: int = -2
    GAMMA_EXP_MAX: int = 2
    EPSILON_EXP_MIN: int = -2
    EPSILON_EXP_MAX: int = 0
    RANDOM_STATE: int = 44
    N_FOLDS: int = 10
    TEST_SIZE: float = 0.2
