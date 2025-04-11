type ButtonProps = {
  children: React.ReactNode;
  onClick?: () => void;
  className?: string;
};

export default function Button({
  children,
  onClick,
  className = "",
}: ButtonProps) {
  const baseClasses =
    "inline-flex items-center gap-2.5 text-orange-500 bg-white py-3 px-6 rounded-[50px] text-[1.1rem] font-semibold mt-3 mb-5 transition-all duration-300 ease-in-out shadow-md cursor-pointer border-none select-none hover:bg-zinc-100 hover:-translate-y-0.5 hover:shadow-lg";

  const buttonClasses = [baseClasses, className].filter(Boolean).join(" ");

  return (
    <button type="button" className={buttonClasses} onClick={onClick}>
      {children}
    </button>
  );
}
