from random import choice
import string


def generate_string():
    random_string = ''.join([choice(string.ascii_letters + string.digits) for n in xrange(8)]) + "@p33.org"
    return random_string


def hash_email(email):
    from hashlib import md5
    return md5(email).hexdigest()
