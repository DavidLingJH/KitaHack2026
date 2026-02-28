from __future__ import annotations

from datetime import UTC, datetime

from sqlalchemy import DateTime, ForeignKey, Integer, String, Text, REAL
from sqlalchemy.orm import Mapped, mapped_column, relationship

from Backend.database import Base # from our own built module

# forward referencing 
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(120), unique=True, nullable=False)
    image_file: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True,
        default=None,
    )

    posts: Mapped[list[Recipe]] = relationship(back_populates="author", cascade="all, delete-orphan")

    @property
    def image_path(self) -> str:
        if self.image_file:
            return f"/media/profile_pics/{self.image_file}"
        return "/static/profile_pics/default.jpg"


class Recipe(Base):
    __tablename__ = "recipe"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    meal_name: Mapped[str] = mapped_column(String(100), nullable=False)
    ingredients: Mapped[str] = mapped_column(Text, nullable=False)
    steps: Mapped[str] = mapped_column(Text, nullable=False)
    cost: Mapped[float] = mapped_column(REAL, nullable=False)
    
    user_id: Mapped[int] = mapped_column(
        ForeignKey("users.id"), # map to the id in the users table above 
        nullable=False,
        index=True,
    )
    date_posted: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        default=lambda: datetime.now(UTC),
    )

    author: Mapped[User] = relationship(back_populates="posts")
    shop_list : Mapped[ShopList] = relationship(back_populates="recipe")
    

class ShopList(Base):
    __tablename__ = "shopping_list"

    sl_id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    item_id: Mapped[int] = mapped_column(String(100), nullable=False)
    item_name: Mapped[str] = mapped_column(Text, nullable=False)
    price: Mapped[float] = mapped_column(REAL, nullable=False)
    
    recipe: Mapped[Recipe] = relationship(back_populates="shop_list")
    

