from contextlib import contextmanager
import sys

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


__connection_string = (
    'mysql+pymysql://root:Sergiomaje99@localhost:3306/personas'
)

engine = None

try:
    engine = create_engine(__connection_string, echo=True)
except Exception as e:
    sys.exit(f'Can\'t connect to the database\n{str(e)}')


SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)

Base = declarative_base()

def init_db():
    try:
        Base.metadata.create_all(engine)
    except Exception as e:
        sys.exit(f'Could not initialize database\n{str(e)}')


@contextmanager
def get_session():
    try:
        db = SessionLocal()
        yield db
    finally:
        db.close()
