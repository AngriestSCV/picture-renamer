import os

def get_var(cfg, key):
    return os.environ.get(key, cfg.get(key, None))

