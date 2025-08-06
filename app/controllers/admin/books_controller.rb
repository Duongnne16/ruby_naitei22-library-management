class Admin::BooksController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    books = Book.search(params[:q]).recent
    @pagy, @books = pagy(books)
  end

  def show
    @book = Book.includes(:author, :publisher).find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = t("admin.books.flash.create.success")
      redirect_to admin_books_path
    else
      flash.now[:alert] = t("admin.books.flash.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      flash[:success] = t("admin.books.flash.update.success")
      redirect_to admin_book_path(@book)
    else
      flash.now[:alert] = t("admin.books.flash.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    flash[:success] = t("admin.books.flash.destroy.success")
    redirect_to admin_books_path
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    unless @book
      redirect_to admin_books_path, alert: t("admin.books.flash.not_found")
    end
  end

  def book_params
    params.require(:book).permit(:title, :description, :publication_year,
                                 :total_quantity, :available_quantity,
                                 :author_id, :publisher_id, :image)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = t("admin.books.flash.please_log_in")
      redirect_to login_url
    end
  end

  def admin_user
    redirect_to(root_url, alert: t("admin.books.flash.access_denied")) unless current_user&.admin?
  end
end
