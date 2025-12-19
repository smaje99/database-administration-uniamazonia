from sqlalchemy import Column, Integer, Text
from sqlalchemy.dialects.mysql import INTEGER
from sqlalchemy.types import CHAR

from database import Base


UnsignedInteger = Integer().with_variant(INTEGER(unsigned=True), 'mysql')


class Persona(Base):
    __tablename__ = 'persona'

    cc_persona = Column(UnsignedInteger, primary_key=True,nullable=False)
    nombre_persona = Column(Text, nullable=False)
    apellido_persona = Column(Text, nullable=False)
    foto_persona = Column(CHAR(24))


class Libro(Base):
    __tablename__ = 'libro'

    id = Column(UnsignedInteger, primary_key=True, nullable=False)
    titulo = Column(Text, nullable=False)
    autor = Column(UnsignedInteger, nullable=False)
    copias = Column(UnsignedInteger, nullable=False)
