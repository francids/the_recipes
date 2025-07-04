export default function Loading() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-white dark:bg-zinc-900">
      <div className="relative w-20 h-20">
        <div className="absolute top-0 left-0 right-0 bottom-0 border-8 border-orange-200 dark:border-zinc-700 rounded-full"></div>
        <div className="absolute top-0 left-0 right-0 bottom-0 border-8 border-transparent border-t-orange-500 dark:border-t-orange-400 rounded-full animate-spin"></div>
      </div>
    </div>
  );
}
